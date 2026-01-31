class_name WinScreen
extends CanvasLayer

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
@onready var countdown: Control = $Countdown
@onready var countdown_animation_player: AnimationPlayer = $Countdown/AnimationPlayer
@onready var menu: VBoxContainer = $Menu
#endregion

#region Event Methods
#endregion
#region Signal Handlers
#endregion
#region Regular Methods
func start_countdown():
	countdown.show()
	countdown_animation_player.play("countdown")


func stop_countdown():
	countdown_animation_player.stop()
	countdown.hide()


func show_menu():
	menu.show()
#endregion
