class_name Player
extends CharacterBody2D

#region Signals
signal attacked(direction)
signal hit(direction)
signal knocked_back(direction)
signal knocked_out
signal recovered
signal upgraded
signal downgraded
#endregion
#region Enums
#endregion
#region Constants

#endregion
#region Static Variables
#endregion
#region @export Variables
@export_group("General")
@export var player_color: Color = Color.YELLOW
@export var player_num = 0
@export_group("Movement")
@export var input_vector_deadzone : float = -1
@export var move_speed : float = 500
@export_group("Attack and Knockback")
@export var attack_radius: float = 100
@export var hit_timer: float = 0.2
@export var knockback_strength: float = 40
@export var knockback_falloff: float = 0.75
@export var knocked_out_duration: float = 2
@export_group("Boss Modifiers")
@export var boss_size_factor = 1.7
@export var boss_knockback_factor = 1.5
@export var boss_move_speed_factor = 0.5
#endregion
#region Regular Variables
var _is_stunned = false:
	set(value):
		stun_indicator.visible = value
		_is_stunned = value
var _is_knocked_out = false:
	set(value):
		stun_indicator.visible = value 
		_is_knocked_out = value
var _knockback_direction = Vector2.ZERO
var _is_boss = false
#endregion
#region @onready Variables
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var attack_area_sprite_2d: Sprite2D = $AttackArea/Sprite2D
@onready var attack_area_collision: CollisionShape2D = $AttackArea/CollisionShape2D
@onready var stun_indicator: Node2D = $StunIndicator
@onready var belt: Belt = $"../Belt"
@onready var knockout_minigame: KnockoutMinigame = $KnockoutMinigame
#endregion

#region Event Methods
func _ready():
	sprite_2d.self_modulate = player_color
	knockout_minigame.finished.connect(_on_knockout_minigame_finished)


func _physics_process(delta):
	velocity = Vector2.ZERO
	_handle_movement()
	_handle_knockback(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack_action" + str(player_num)):
		if _is_knocked_out:
			knockout_minigame.increase_progress()
		elif !_is_stunned:
			attack_area_collision.disabled = false
			attacked.emit()
			await get_tree().create_timer(hit_timer, false, true, false).timeout
			attack_area_collision.set_deferred("disabled", true)
#endregion
#region Signal Handlers
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Player and body != self:
		var direction = (attack_area.global_position - global_position).normalized()
		hit.emit(direction)
		body.get_hit(direction)


func _on_knockout_minigame_finished():
	_is_knocked_out = false
	recovered.emit()
#endregion
#region Regular Methods
func get_hit(direction):
	knocked_back.emit(direction)
	_is_stunned = true
	_knockback_direction = direction


func get_knocked_out():
	if !_is_stunned: return
	
	if _is_boss: downgrade_player()
	
	_knockback_direction = Vector2.ZERO
	_is_stunned = false
	_is_knocked_out = true
	knockout_minigame.setup(10)
	knocked_out.emit(_knockback_direction)


func upgrade_player():
	if _is_boss: return
	
	_is_boss = true
	scale *= Vector2.ONE * boss_size_factor
	move_speed *= boss_move_speed_factor
	knockback_strength *= boss_knockback_factor
	upgraded.emit()


func downgrade_player():
	if !_is_boss: return
	
	_is_boss = false
	scale /= Vector2.ONE * boss_size_factor
	move_speed /= boss_move_speed_factor
	knockback_strength /= boss_knockback_factor
	downgraded.emit()
	
	belt.position = position
	belt.show()
	belt.handle_spawn_animation()


func _handle_movement():
	var input_vector = Input.get_vector("move_left" + str(player_num), \
		"move_right" + str(player_num), "move_up" + str(player_num), "move_down" + str(player_num), input_vector_deadzone)
	if input_vector != Vector2.ZERO:
		attack_area.position = input_vector.normalized() * attack_radius

	if !_is_stunned and !_is_knocked_out:
		velocity = input_vector * move_speed


func _handle_knockback(delta):
	if _knockback_direction == Vector2.ZERO: return
	
	velocity += _knockback_direction * knockback_strength * 1 / delta

	_knockback_direction *= knockback_falloff
	if is_zero_approx(velocity.length()):
		_knockback_direction = Vector2.ZERO
		_is_stunned = false
		recovered.emit()
#endregion
