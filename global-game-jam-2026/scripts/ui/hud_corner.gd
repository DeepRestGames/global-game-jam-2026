class_name HudCorner
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
var player_id: int
var player: Player
#endregion
#region Regular Variables
#endregion
#region @onready Variables
@onready var texture_progress_bar: TextureProgressBar = $VBoxContainer/AspectRatioContainer/TextureProgressBar
@onready var button_animation: ButtonAnimation = $ButtonAnimation
@onready var label: Label = $VBoxContainer/AspectRatioContainer/Label
#endregion

#region Event Methods
func _ready():
	player = get_tree().get_nodes_in_group("Player").filter( \
		func(x): return x.player_num == player_id)[0] as Player
	player.knockout_minigame_setup.connect(_on_player_knockout_minigame_setup)
	player.knockout_minigame_progress.connect(_on_player_knockout_minigame_progress)
	player.recovered.connect(_on_player_recovered)
#endregion
#region Signal Handlers
func _on_player_knockout_minigame_setup(max_value):
	texture_progress_bar.value = 0
	texture_progress_bar.max_value = max_value
	label.show()
	button_animation.show()


func _on_player_knockout_minigame_progress():
	texture_progress_bar.value += 1

func _on_player_recovered():
	label.hide()
	button_animation.hide()
#endregion
#region Regular Methods
#endregion
