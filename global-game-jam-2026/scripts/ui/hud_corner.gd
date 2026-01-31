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
#endregion

#region Event Methods
#endregion
#region Signal Handlers
func _on_player_knocked_out():
	pass
#endregion
#region Regular Methods
func _fetch_player():
	player = get_tree().get_nodes_in_group("Player").filter(func(x): x.player_num == player_id)[0] as Player
	player.knocked_out.connect(_on_player_knocked_out)
#endregion
