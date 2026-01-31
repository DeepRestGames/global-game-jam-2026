class_name Player
extends CharacterBody2D

#region Signals
signal attacked(direction)
signal hit(force)
signal knocked_back(force)
signal knocked_out
signal recovered
signal knockback_recovered
signal upgraded(player)
signal downgraded(player)
signal move(direction)
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
@export_enum("MASKCACHO", "EL MASKADOR", "MASKERIÑO", "MASKALIENTE") var player_name: String = "MASKCACHO"
@export var player_num = 0
@export var base_sprite_sheet: Texture2D
@export_group("Movement")
@export var input_vector_deadzone : float = -1
@export var move_speed : float = 500
@export_group("Attack and Knockback")
@export var attack_radius: float = 100
@export var hit_timer: float = 0.2
@export var knockback_strength: float = 1000
@export var knockback_falloff: float = 0.0001
@export var knocked_out_duration: float = 2
@export_group("Boss Modifiers")
@export var boss_size_factor = 1.7
@export var boss_move_speed_factor = 0.5
@export var boss_knockback_strength: float = 3000
#endregion
#region Regular Variables
var _is_input_active: bool = true
var _is_stunned = false
var _is_knocked_out = false
var _knockback_force = Vector2.ZERO
var _is_boss = false
#endregion
#region @onready Variables
@onready var sprite_2d: Sprite2D = $SpritePivot/Sprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var attack_area_sprite_2d: Sprite2D = $AttackArea/Sprite2D
@onready var attack_area_collision: CollisionShape2D = $AttackArea/CollisionShape2D
@onready var player_indicator_sprite: Sprite2D = $PlayerIndicatorSprite
@onready var belt: Belt = $"../Belt"
@onready var knockout_minigame: KnockoutMinigame = $KnockoutMinigame
@onready var the_mask_sprite_sheet: Texture2D = preload("res://art/player/the_mask_sprite_sheet.png")
#endregion

#region Event Methods
func _ready():
	sprite_2d.self_modulate = player_color
	sprite_2d.texture = base_sprite_sheet
	player_indicator_sprite.self_modulate = player_color
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
	if body is not Player or body == self: return

	var direction = (attack_area.global_position - global_position).normalized()
	var hit_force = direction * (boss_knockback_strength if _is_boss else knockback_strength)
	hit.emit(hit_force)
	body.get_hit(hit_force)


func _on_knockout_minigame_finished():
	_is_knocked_out = false
	recovered.emit()
#endregion
#region Regular Methods
func get_hit(force):
	knocked_back.emit(force)
	_is_stunned = true
	_knockback_force = force


func get_knocked_out():
	if !_is_stunned: return
	
	if _is_boss: downgrade_player()
	
	_knockback_force = Vector2.ZERO
	_is_stunned = false
	_is_knocked_out = true
	knockout_minigame.setup(10)
	knocked_out.emit(_knockback_force)


func upgrade_player():
	if _is_boss: return
	
	_is_boss = true
	scale *= Vector2.ONE * boss_size_factor
	move_speed *= boss_move_speed_factor
	upgraded.emit(self)


func downgrade_player():
	if !_is_boss: return
	
	_is_boss = false
	scale /= Vector2.ONE * boss_size_factor
	move_speed /= boss_move_speed_factor
	downgraded.emit(self)
	
	belt.position = position
	belt.show()
	belt.handle_spawn_animation()


func _handle_movement():
	if not _is_input_active: return
	
	var input_vector = Input.get_vector("move_left" + str(player_num), \
		"move_right" + str(player_num), "move_up" + str(player_num), "move_down" + str(player_num), input_vector_deadzone)
	if input_vector != Vector2.ZERO:
		attack_area.position = input_vector.normalized() * attack_radius
		player_indicator_sprite.rotation = input_vector.angle()

	if !_is_stunned and !_is_knocked_out:
		velocity = input_vector * move_speed
	
	if !is_zero_approx(velocity.length()):
		move.emit(velocity)


func _handle_knockback(delta):
	if _knockback_force == Vector2.ZERO: return
	
	velocity += _knockback_force

	_knockback_force *= pow(knockback_falloff, delta)
	if is_zero_approx(velocity.length()):
		_knockback_force = Vector2.ZERO
		_is_stunned = false
		knockback_recovered.emit()
#endregion
