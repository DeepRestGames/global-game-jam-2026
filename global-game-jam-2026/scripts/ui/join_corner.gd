class_name JoinCorner
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
@export var hud: HudCorner
@export var player_id: int
#endregion
#region Regular Variables
#endregion
#region @onready Variables
#endregion

#region Event Methods
func _ready() -> void:
	hud.player_id = player_id


func _input(event: InputEvent) -> void:
	if not visible: return
	
	if event.is_action_pressed("attack_action" + str(player_id)):
		hide()
		hud.show()
#endregion
#region Signal Handlers
#endregion
#region Regular Methods
#endregion
