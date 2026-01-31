class_name PlayerAnimation
extends Node

#region Signals
#endregion
#region Enums
#endregion
#region Constants
#endregion
#region Static Variables
#endregion
#region @export Variables
#endregion
#region Regular Variables
var looking_right = true
#endregion
#region @onready Variables
@onready var player: Player = $".."
@onready var sprite_2d: Sprite2D = $"../SpritePivot/Sprite2D"
@onready var animation_player: AnimationPlayer = $AnimationPlayer
#endregion

#region Event Methods
#endregion
#region Signal Handlers

func on_attacked() -> void:
	if looking_right:
		animation_player.play("attacked_right")
	else:
		animation_player.play("attacked_left")

func on_knocked_out() -> void:
	if looking_right:
		animation_player.play("knocked_out_right")
	else:
		animation_player.play("knocked_out_left")

func on_recovered() -> void:
	if player._is_knocked_out:
		return
	
	if looking_right:
		animation_player.play("recovered_right")
	else:
		animation_player.play("recovered_left")

func on_knocked_back() -> void:
	if player._is_knocked_out:
		return
	
	if looking_right:
		animation_player.play("knocked_back_right")
	else:
		animation_player.play("knocked_back_left")

func on_move(direction: Vector2) -> void:
	if direction.normalized().x > 0:
		looking_right = true
		if animation_player.current_animation == "recovered_left":
			animation_player.play("recovered_right")
	else:
		looking_right = false
		if animation_player.current_animation == "recovered_right":
			animation_player.play("recovered_left")

func on_animation_finished(animation_name) -> void:
	if animation_name == "attacked_right" or animation_name == "attacked_left":
		on_recovered()

#endregion
#region Regular Methods

func _ready() -> void:
	on_recovered()
	
	player.attacked.connect(on_attacked)
	player.knocked_back.connect(on_knocked_back.unbind(1))
	player.knocked_out.connect(on_knocked_out.unbind(1))
	player.recovered.connect(on_recovered)
	player.knockback_recovered.connect(on_recovered)
	
	animation_player.connect("animation_finished", on_animation_finished)
	
	player.move.connect(on_move)

#endregion
