extends Node


@export var player_num = 0

#var player_input_signals : Dictionary = {}

signal player_movement
signal player_punch


#func _ready() -> void:
	
	#var s_name = "player_movement" + str(player_num)
	
	#player_input_signals[s_name] = Signal(self, s_name)


func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("punch" + str(player_num)):
		emit_signal("player_punch")
	
	var movement_direction = Input.get_vector("move_left" + str(player_num), "move_right" + str(player_num), "move_up" + str(player_num), "move_down" + str(player_num))
	emit_signal("player_movement", movement_direction)

	#player_input_signals["player_movement"].emit()
