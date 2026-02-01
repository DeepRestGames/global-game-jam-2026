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
@onready var the_mask_sprite_sheet: Texture2D = preload("res://art/player/the_mask_sprite_sheet.png")
#endregion

#region Event Methods
#endregion
#region Signal Handlers

func on_attacked() -> void:
	if looking_right:
		if player._is_boss:
			animation_player.play("attacked_right_boss")
		else:
			animation_player.play("attacked_right")
	else:
		if player._is_boss:
			animation_player.play("attacked_left_boss")
		else:
			animation_player.play("attacked_left")

func on_knocked_out() -> void:
	if looking_right:
		if player._is_boss:
			animation_player.play("knocked_out_right_boss")
		else:
			animation_player.play("knocked_out_right")
	else:
		if player._is_boss:
			animation_player.play("knocked_out_left_boss")
		else:
			animation_player.play("knocked_out_left")

func on_recovered() -> void:
	if player.is_knocked_out:
		return
	
	if looking_right:
		if player._is_boss:
			animation_player.play("recovered_right_boss")
		else:
			animation_player.play("recovered_right")
	else:
		if player._is_boss:
			animation_player.play("recovered_left_boss")
		else:
			animation_player.play("recovered_left")

func on_knocked_back(direction: Vector2) -> void:
	if player.is_knocked_out:
		return
	
	if direction.normalized().x > 0:
		if player._is_boss:
			animation_player.play("knocked_back_right_boss")
		else:
			animation_player.play("knocked_back_right")
	else:
		if player._is_boss:
			animation_player.play("knocked_back_left_boss")
		else:
			animation_player.play("knocked_back_left")

func on_move(direction: Vector2) -> void:
	if direction.normalized().x > 0:
		looking_right = true
		if animation_player.current_animation == "recovered_left" or \
		animation_player.current_animation == "recovered_left_boss":
			if player._is_boss:
				animation_player.play("recovered_right_boss")
			else:
				animation_player.play("recovered_right")
	else:
		looking_right = false
		if animation_player.current_animation == "recovered_right" or \
		animation_player.current_animation == "recovered_right_boss":
			if player._is_boss:
				animation_player.play("recovered_left_boss")
			else:
				animation_player.play("recovered_left")

func on_animation_finished(animation_name) -> void:
	if animation_name == "attacked_right" or animation_name == "attacked_left" \
	or animation_name == "attacked_right_boss" or animation_name == "attacked_left_boss":
		on_recovered()


func on_upgraded() -> void:
	sprite_2d.texture = the_mask_sprite_sheet
	on_recovered()

func on_downgraded() -> void:
	sprite_2d.texture = player.base_sprite_sheet
	on_recovered()


#endregion
#region Regular Methods
func setup(is_looking_right: bool) -> void:
	looking_right = is_looking_right
	on_recovered()
	
	player.attacked.connect(on_attacked)
	player.knocked_back.connect(on_knocked_back)
	player.knocked_out.connect(on_knocked_out.unbind(1))
	player.recovered.connect(on_recovered)
	player.knockback_recovered.connect(on_recovered)
	player.upgraded.connect(on_upgraded.unbind(1))
	player.downgraded.connect(on_downgraded.unbind(1))
	
	animation_player.connect("animation_finished", on_animation_finished)
	
	player.move.connect(on_move)

#endregion
