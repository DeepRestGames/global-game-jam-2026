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
@export var normal_attack_screenshake_amount: float = 10
@export var heavy_attack_freeze_frame_duration: float = 0.5
@export var heavy_attack_freeze_frame_screenshake_amount: float = 5
@export var heavy_attack_freeze_frame_screenshake_interval: float = 0.05
@export var heavy_attack_screenshake_amount: float = 20
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
@onready var win_screen: CanvasLayer = $WinScreen
#endregion

#region Event Methods
func _ready() -> void:
	GameManager.register_player_signals()
	GameManager.register_win_screen(win_screen)
	CrowdManager.setup_players()
	players.append_array(find_children("*", "Player", false))
	for player in players:
		player.knocked_back.connect(_on_player_knocked_back)
#endregion
#region Signal Handlers
func _on_player_knocked_back(direction: Vector2):
	camera_2d.shake(direction.normalized(), normal_attack_screenshake_amount)
	
	# TODO: do these on heavy knockback
	#freeze_frame(heavy_attack_freeze_frame_duration)
	#screenshake_dir = direction.normalized()
	#screenshake_amount = heavy_attack_screenshake_amount


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
	freeze_frame_tween.tween_callback(camera_2d.shake.bind(Vector2.ZERO, heavy_attack_freeze_frame_screenshake_amount))
	freeze_frame_tween.tween_interval(heavy_attack_freeze_frame_screenshake_interval)
	
	freeze_frame_timer.start(duration)
#endregion
