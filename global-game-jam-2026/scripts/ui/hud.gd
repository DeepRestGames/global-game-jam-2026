class_name Hud
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
#endregion
#region Regular Variables
#endregion
#region @onready Variables
#endregion

#region Event Methods
#endregion
#region Signal Handlers
#endregion
#region Regular Methods
func hide_join_ui(player_num):
	var found_ui: JoinCorner
	found_ui = get_tree().get_nodes_in_group("JoinUI").filter(func(jc: JoinCorner): return jc.player_id == player_num)[0]
	if found_ui: found_ui.hide()
#endregion
