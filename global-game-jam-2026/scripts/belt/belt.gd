class_name Belt
extends Area2D

#region Signals
#endregion
#region Enums
#endregion
#region Constants
#endregion
#region Static Variables
#endregion
#region @export Variables
@export var bounce_height: float = 200
@export var bounce_up_duration: float = 0.3
@export var bounce_down_duration: float = 0.85
@export var is_active = false
#endregion
#region Regular Variables
#endregion
#region @onready Variables
#endregion

#region Event Methods
#endregion
#region Signal Handlers
func _on_body_entered(body: Node2D) -> void:
	if !is_active: return
	
	if body is Player:
		body.upgrade_player()
		hide()
		is_active = false
#endregion
#region Regular Methods
func handle_spawn_animation():
	var tween_y = create_tween()
	tween_y.set_ease(Tween.EASE_OUT)
	tween_y.set_trans(Tween.TRANS_SINE)
	tween_y.tween_property(self, "position:y", position.y - bounce_height, bounce_up_duration)
	tween_y.set_ease(Tween.EASE_OUT)
	tween_y.set_trans(Tween.TRANS_BOUNCE)
	tween_y.tween_property(self, "position:y", 0, bounce_down_duration)
	var tween_x = create_tween()
	tween_x.set_ease(Tween.EASE_OUT)
	tween_x.set_trans(Tween.TRANS_SINE)
	tween_x.tween_property(self, "position:x", 0, bounce_up_duration + bounce_down_duration)
	tween_x.tween_callback(func(): is_active = true)
#endregion
