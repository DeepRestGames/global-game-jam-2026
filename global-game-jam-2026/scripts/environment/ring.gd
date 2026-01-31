class_name Ring
extends Node2D

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
func _on_border_body_entered(body: Node2D) -> void:
	print("border entered!")


func _on_border_body_exited(body: Node2D) -> void:
	print("border exited!")
#endregion
#region Regular Methods
#endregion
