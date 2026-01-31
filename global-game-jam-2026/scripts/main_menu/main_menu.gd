class_name MainMenu
extends Control

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
#endregion
#region Regular Variables
#endregion
#region @onready Variables
#endregion

#region Event Methods
func _ready() -> void:
	assert(game_scene != null, "Game scene reference is not set.")
#endregion
#region Signal Handlers
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
#endregion
#region Regular Methods
#endregion
