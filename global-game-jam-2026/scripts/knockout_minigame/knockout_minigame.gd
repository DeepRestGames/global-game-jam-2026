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
#endregion
#region @onready Variables
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
#endregion

#region Event Methods
#endregion
#region Signal Handlers
#endregion
#region Regular Methods
func setup(max_value):
	texture_progress_bar.value = 0
	texture_progress_bar.max_value = max_value
	#show() # TODO removed temporarily, maybe re-added after playtest


func increase_progress():
	texture_progress_bar.value += 1
	if texture_progress_bar.value >= texture_progress_bar.max_value:
		finished.emit()
		#hide() # TODO removed temporarily, maybe re-added after playtest
#endregion
