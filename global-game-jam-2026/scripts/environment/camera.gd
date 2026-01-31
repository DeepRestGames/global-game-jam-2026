class_name Camera
extends Camera2D

#region Signals
#endregion
#region Enums
#endregion
#region Constants
#endregion
#region Static Variables
#endregion
#region @export Variables
@export var screenshake_strength: float = 50
@export var falloff_factor: float = 0.95
#endregion
#region Regular Variables
#endregion
#region @onready Variables
#endregion

#region Event Methods
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shake_screen"):
		shake(Vector2.LEFT, screenshake_strength)


func _process(delta: float) -> void:
	offset *= falloff_factor
#endregion
#region Signal Handlers
#endregion
#region Regular Methods
func shake(dir: Vector2, amount: float):
	offset += dir * amount


func _get_random_dir():
	return Vector2.from_angle(randf_range(0, 360)).normalized()
#endregion
