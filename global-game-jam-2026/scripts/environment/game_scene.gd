class_name GameScene
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
@export var charge_attack_freeze_frame_duration: float = 0.5
@export var charge_attack_freeze_frame_screenshake_amount: float = 0.5
@export var charge_attack_freeze_frame_screenshake_interval: float = 0.05
@export var charge_attack_screenshake_amount: float = 20
#endregion
#region Regular Variables
var players: Array

var freeze_frame_tween: Tween
var screenshake_dir: Vector2
var screenshake_amount: float
#endregion
#region @onready Variables
@onready var camera_2d: Camera = $Camera2D
@onready var freeze_frame_timer: Timer = $FreezeFrameTimer
#endregion

#region Event Methods
func _ready() -> void:
	players.append_array(find_children("*", "Player", false))
	
	for player in players:
		player.knocked_back.connect(_on_player_knocked_back)
#endregion
#region Signal Handlers
func _on_player_knocked_back(direction: Vector2):
	freeze_frame(charge_attack_freeze_frame_duration)
	screenshake_dir = direction.normalized()
	screenshake_amount = charge_attack_screenshake_amount


func _on_freeze_frame_timer_timeout() -> void:
	if freeze_frame_tween:
		freeze_frame_tween.kill()
		freeze_frame_tween = null
	
	get_tree().paused = false
	camera_2d.shake(screenshake_dir, screenshake_amount)
	
#endregion
#region Regular Methods
func freeze_frame(duration: float):
	if freeze_frame_tween:
		freeze_frame_tween.kill()
		freeze_frame_tween = null
	
	get_tree().paused = true
	freeze_frame_tween = create_tween()
	freeze_frame_tween.set_loops()
	freeze_frame_tween.tween_callback(camera_2d.shake.bind(Vector2.ZERO, charge_attack_freeze_frame_screenshake_amount))
	freeze_frame_tween.tween_interval(charge_attack_freeze_frame_screenshake_interval)
	
	freeze_frame_timer.start(duration)


func _set_player_input_active(value: bool):
	for player in players:
		player.set_input_active(value)
#endregion
