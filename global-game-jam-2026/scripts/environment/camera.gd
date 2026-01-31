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
func _process(delta: float) -> void:
	offset *= falloff_factor * 1 / delta
#endregion
#region Signal Handlers
#endregion
#region Regular Methods
func shake(dir: Vector2, amount: float):
	if dir == Vector2.ZERO: offset += _get_random_dir() * amount
	else: offset += dir * amount


func freeze_frame(duration: float):
	Engine.time_scale = 0
	await get_tree().create_timer(duration, false, false, true).timeout
	Engine.time_scale = 1


func _get_random_dir():
	return Vector2.from_angle(randf_range(0, 360)).normalized()
#endregion
