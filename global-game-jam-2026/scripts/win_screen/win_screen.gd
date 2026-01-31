class_name WinScreen
extends CanvasLayer

#region Signals
#endregion
#region Enums
#endregion
#region Constants
#endregion
#region Static Variables
#endregion
#region @export Variables
@export var game_scene: PackedScene
@export var menu_scene: PackedScene
#endregion
#region Regular Variables
var _winning_player: Player
#endregion
#region @onready Variables
@onready var countdown: Control = $Countdown
@onready var countdown_animation_player: AnimationPlayer = $Countdown/AnimationPlayer
@onready var menu: Control = $Menu
@onready var player_name: Label = $Menu/MarginContainer/BoxContainer/PlayerName
#endregion

#region Event Methods
#endregion
#region Signal Handlers
func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(menu_scene)


func _on_restart_game_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)
#endregion
#region Regular Methods
func set_winning_player(player: Player):
	_winning_player = player


func start_countdown():
	countdown.show()
	countdown_animation_player.play("countdown")


func stop_countdown():
	countdown_animation_player.stop()
	countdown.hide()


func show_menu():
	player_name.text = _winning_player.player_name
	player_name.modulate = _winning_player.player_color
	menu.show()
#endregion
