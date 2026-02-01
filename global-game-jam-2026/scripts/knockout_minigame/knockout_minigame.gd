class_name KnockoutMinigame
extends Control

#region Signals
signal finished
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
var _knockout_progress_value = 0
var _knockout_progress_max = 100
#endregion
#region @onready Variables
@onready var button_animation: ButtonAnimation = $ButtonAnimation
#endregion

#region Event Methods
#endregion
#region Signal Handlers
#endregion
#region Regular Methods
func setup(max_value):
	_knockout_progress_value = 0
	_knockout_progress_max = max_value
	button_animation.show()


func increase_progress():
	_knockout_progress_value += 1
	if _knockout_progress_value >= _knockout_progress_max:
		finished.emit()
		button_animation.hide()
#endregion
