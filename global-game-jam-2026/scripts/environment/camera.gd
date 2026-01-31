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
@export var screenshake_strength: float = 100
@export var falloff_factor: float = 0.05
#endregion
#region Regular Variables
#endregion
#region @onready Variables
#endregion

#region Event Methods
func _process(delta: float) -> void:
	offset *= pow(falloff_factor, delta)
#endregion
#region Signal Handlers
#endregion
#region Regular Methods
func shake(dir: Vector2, amount: float):
	if dir == Vector2.ZERO: offset += _get_random_dir() * amount
	else: offset += dir * amount


func _get_random_dir():
	return Vector2.from_angle(randf_range(0, 360)).normalized()
#endregion
