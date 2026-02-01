class_name Player
extends CharacterBody2D

#region Signals
signal joined
signal spawned
signal attacked(direction)
signal hit(force)
signal hit_as_boss(force)
signal knocked_back(force)
signal knocked_out
signal recovered
signal knockback_recovered
signal upgraded(player)
signal downgraded(player)
signal move(direction)
signal knockout_minigame_setup(value: float)
signal knockout_minigame_progress()
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
@export var is_looking_right: bool = true
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
@export var stun_recovery_threshold: float = 10
@export var knocked_out_duration: float = 2
@export var knockback_minigame_max: float = 10
@export var knockback_minigame_growth : float = 5
@export_group("Boss Modifiers")
@export var boss_size_factor = 1.7
@export var boss_move_speed_factor = 0.5
@export var boss_knockback_strength: float = 3000
#endregion
#region Regular Variables
var _is_spawned: bool = false
var _is_stunned = false
var is_knocked_out = false
var _knockback_force = Vector2.ZERO
var _is_boss = false
#endregion
#region @onready Variables
@onready var sprite_2d: Sprite2D = $SpritePivot/Sprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var attack_area_collision: CollisionShape2D = $AttackArea/CollisionShape2D
@onready var player_indicator_sprite: Sprite2D = $PlayerIndicatorSprite
@onready var belt: Belt = $"../Belt"
@onready var knockout_minigame: KnockoutMinigame = $KnockoutMinigame
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var player_animation: PlayerAnimation = $PlayerAnimation
#endregion

#region Event Methods
func _ready():
	knockout_minigame.finished.connect(_on_knockout_minigame_finished)
	
	sprite_2d.self_modulate = player_color
	sprite_2d.texture = base_sprite_sheet
	player_indicator_sprite.self_modulate = player_color


func _physics_process(delta):
	velocity = Vector2.ZERO
	_handle_movement()
	_handle_knockback(delta)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if not _is_spawned: return

	if event.is_action_pressed("attack_action" + str(player_num)):
		if is_knocked_out:
			knockout_minigame.increase_progress()
			knockout_minigame_progress.emit()
		elif !_is_stunned:
			attack_area_collision.disabled = false
			attacked.emit()
			await get_tree().create_timer(hit_timer, false, true, false).timeout
			attack_area_collision.set_deferred("disabled", true)
#endregion
#region Signal Handlers
func _on_knockout_minigame_finished():
	knockback_minigame_max += knockback_minigame_growth
	is_knocked_out = false
	recovered.emit()


func _on_attack_area_area_entered(area: Area2D) -> void:
	var player = area.get_parent()
	if player is not Player or player == self: return

	var direction = (attack_area.global_position - global_position).normalized()
	var hit_force = direction * (boss_knockback_strength if _is_boss else knockback_strength)
	if _is_boss: hit_as_boss.emit(hit_force)
	hit.emit(hit_force)
	player.get_hit(hit_force)
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
	is_knocked_out = true
	knockout_minigame.setup(knockback_minigame_max)
	knockout_minigame_setup.emit(knockback_minigame_max)
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


func join():
	player_animation.setup(is_looking_right)
	player_indicator_sprite.rotation_degrees = 0 if is_looking_right else 180
	joined.emit()


func spawn_in():
	collision_shape_2d.disabled = false
	_is_spawned = true
	spawned.emit()


func _handle_movement():
	if not _is_spawned: return
	
	var input_vector = Input.get_vector("move_left" + str(player_num), \
		"move_right" + str(player_num), "move_up" + str(player_num), "move_down" + str(player_num), input_vector_deadzone)
	if input_vector != Vector2.ZERO:
		attack_area.position = input_vector.normalized() * attack_radius
		player_indicator_sprite.rotation = input_vector.angle()

	if !_is_stunned and !is_knocked_out:
		velocity = input_vector * move_speed
	
	if !is_zero_approx(velocity.length()):
		move.emit(velocity)


func _handle_knockback(delta):
	if _knockback_force == Vector2.ZERO: return
	
	velocity += _knockback_force

	_knockback_force *= pow(knockback_falloff, delta)
	if velocity.length() <= stun_recovery_threshold:
		_knockback_force = Vector2.ZERO
		_is_stunned = false
		knockback_recovered.emit()
#endregion
