class_name Crowd
extends Node

#region Signals
#endregion
#region Enums
#endregion
#region Constants
#endregion
#region Static Variables
#endregion
#region @export Variables
@export var loop2_starting_volume = -10.0
@export var loop2_max_volume = 0.0
#endregion
#region Regular Variables
#endregion
#region @onready Variables
@onready var cheer: AudioStreamPlayer = $Sounds/Cheer
@onready var loop_1: AudioStreamPlayer = $Sounds/Loop1
@onready var loop_2: AudioStreamPlayer = $Sounds/Loop2
@onready var el_maskador: AudioStreamPlayer = $Sounds/ElMaskador
@onready var maskaliente: AudioStreamPlayer = $Sounds/Maskaliente
@onready var maskchacho: AudioStreamPlayer = $Sounds/Maskchacho
@onready var maskerino: AudioStreamPlayer = $Sounds/Maskerino
#endregion

#region Event Methods
#endregion
#region Signal Handlers

func update_crowd_loudness(engagement_value: float) -> void:
	loop_2.volume_db = clamp(loop2_starting_volume + engagement_value, loop2_starting_volume, loop2_max_volume) 

func on_player_won(player_name) -> void:
	print("Player won" + str(player_name))
	
	if player_name == "MASKCACHO":
		maskchacho.play()
	elif player_name == "EL MASKADOR":
		el_maskador.play()
	elif player_name == "MASKERIÑO":
		maskerino.play()
	elif player_name == "MASKALIENTE":
		maskaliente.play()

#endregion
#region Regular Methods

func _ready() -> void:
	CrowdManager.connect("update_engagement_value", update_crowd_loudness)
	var win_screen = get_tree().get_first_node_in_group("WinScreen") as WinScreen
	win_screen.player_won.connect(on_player_won)
	
#endregion
