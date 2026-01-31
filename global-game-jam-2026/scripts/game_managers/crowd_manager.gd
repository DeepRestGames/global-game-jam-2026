extends Node

#region Signals

signal update_engagement_value(engagement_value: float)

#endregion
#region Enums
#endregion
#region Constants
#endregion
#region Static Variables
#endregion
#region @export Variables

@export var knockback_engagement_value: float = 0.2
@export var knockout_engagement_value: float = 0.5

#endregion
#region Regular Variables

var engagement_value: float = 0
var min_engagement_value: float = 0.0
var max_engagement_value: float = 8.0

#endregion
#region @onready Variables
#endregion

#region Event Methods
#endregion
#region Signal Handlers
#endregion
#region Regular Methods


func setup_players() -> void:
	var players = get_tree().get_nodes_in_group("Player") as Array[Player]
	for player in players:
		player.knocked_back.connect(on_knockback.unbind(1))
		player.knocked_out.connect(on_knockout.unbind(1))


func on_knockback() -> void:
	engagement_value += knockback_engagement_value
	engagement_value = clampf(engagement_value, min_engagement_value, max_engagement_value)
	emit_signal("update_engagement_value", engagement_value)


func on_knockout() -> void:
	engagement_value += knockout_engagement_value
	engagement_value = clampf(engagement_value, min_engagement_value, max_engagement_value)
	emit_signal("update_engagement_value", engagement_value)


#endregion
