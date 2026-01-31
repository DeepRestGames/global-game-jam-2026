class_name Player
extends CharacterBody2D

#region Signals
signal attacked(direction)
signal hit(direction)
signal knocked_back(direction)
signal knocked_out
signal recovered
#endregion
#region Enums
#endregion
#region Constants

#endregion
#region Static Variables
#endregion
#region @export Variables
@export var player_color: Color = Color.YELLOW
@export var player_num = 0
@export var move_speed : float = 500
@export var attack_radius: float = 100
@export var hit_timer: float = 0.2
@export var knockback_strength: float = 500
@export var knockback_falloff: float = 0.0001
@export var knocked_out_duration: float = 2
@export var input_vector_deadzone : float = -1
#endregion
#region Regular Variables
var _is_input_active: bool = true
var _is_stunned = false:
	set(value):
		stun_indicator.visible = value
		_is_stunned = value
var _is_knocked_out = false:
	set(value):
		stun_indicator.visible = value
		_is_knocked_out = value
var _knockback_direction = Vector2.ZERO
#endregion
#region @onready Variables
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var attack_area_sprite_2d: Sprite2D = $AttackArea/Sprite2D
@onready var attack_area_collision: CollisionShape2D = $AttackArea/CollisionShape2D
@onready var stun_indicator: Node2D = $StunIndicator
#endregion

#region Event Methods
func _ready():
	sprite_2d.self_modulate = player_color


func _physics_process(delta):
	velocity = Vector2.ZERO
	_handle_movement()
	_handle_knockback(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if not _is_input_active: return
	
	if event.is_action_pressed("attack_action" + str(player_num)):
		attack_area_collision.disabled = false
		attacked.emit()
		await get_tree().create_timer(hit_timer, false, true, false).timeout
		attack_area_collision.set_deferred("disabled", true)
#endregion
#region Signal Handlers
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is not Player or body == self: return
	
	var direction = (attack_area.global_position - global_position).normalized()
	hit.emit(direction)
	body.get_hit(direction)
#endregion
#region Regular Methods
func get_hit(direction):
	knocked_back.emit(direction)
	_is_stunned = true
	_knockback_direction = direction


func get_knocked_out():
	if !_is_stunned: return
	
	_knockback_direction = Vector2.ZERO
	_is_knocked_out = true
	knocked_out.emit(_knockback_direction)
	await get_tree().create_timer(knocked_out_duration, false, true, false).timeout
	_is_knocked_out = false
	recovered.emit()


func _handle_movement():
	if not _is_input_active: return
	
	var input_vector = Input.get_vector("move_left" + str(player_num), \
		"move_right" + str(player_num), "move_up" + str(player_num), "move_down" + str(player_num), input_vector_deadzone)
	if input_vector != Vector2.ZERO:
		attack_area.position = input_vector.normalized() * attack_radius

	if !_is_stunned:
		velocity = input_vector * move_speed


func _handle_knockback(delta):
	if _knockback_direction == Vector2.ZERO: return
	
	velocity += _knockback_direction * knockback_strength

	_knockback_direction *= pow(knockback_falloff, delta)
	if is_zero_approx(velocity.length()):
		_knockback_direction = Vector2.ZERO
		_is_stunned = false
		recovered.emit()
#endregion
