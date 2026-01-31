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
#endregion
#region Regular Variables

var engagement_value: float = 0.0
var max_engagement_value: float = 10.0

#endregion
#region @onready Variables
#endregion

#region Event Methods
#endregion
#region Signal Handlers
#endregion
#region Regular Methods

func _ready() -> void:
	emit_signal("update_engagement_value", engagement_value)
	
	# TODO Add connection to knockout, countdown and other signals that should generate a reaction in the crowd


func on_knockout() -> void:
	engagement_value += 5
	engagement_value = clampf(engagement_value, 0.0, max_engagement_value)
	emit_signal("update_engagement_value", engagement_value)

#endregion
