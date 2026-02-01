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

@export var spawn_in_duration: float = 2
@export var spawn_in_jump_height: float = 100

@export var belt_spawn_duration: float = 1
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
@onready var player_1_spawn: Marker2D = $SpawnPoints/Player1Spawn
@onready var player_2_spawn: Marker2D = $SpawnPoints/Player2Spawn
@onready var player_3_spawn: Marker2D = $SpawnPoints/Player3Spawn
@onready var player_4_spawn: Marker2D = $SpawnPoints/Player4Spawn
@onready var belt: Belt = $Belt
@onready var belt_shadow_spawn_in: Sprite2D = $BeltShadowSpawnIn
@onready var tutorial: Control = $Ring/Control
@onready var hud: Hud = $HUD
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var bell_start: AudioStreamPlayer = $Sounds/Bell_start
@onready var bell_end: AudioStreamPlayer = $Sounds/Bell_end
#endregion

#region Event Methods
func _ready() -> void:
	get_tree().paused = false
	audio_stream_player.play()
	
	GameManager.spawned_players = 0
	GameManager.register_player_signals()
	GameManager.register_player_corners()
	GameManager.register_win_screen(win_screen)
	GameManager.register_hud(hud)
	GameManager.register_game_scene(self)
	CrowdManager.setup_players()
	players.append_array(find_children("*", "Player", false))
	for player in players:
		player.knocked_back.connect(_on_player_knocked_back)
		player.hit_as_boss.connect(_on_player_hit_as_boss)
	
	win_screen.when_ko_label_is_shown.connect(on_player_won)
	
#endregion
#region Signal Handlers
func _on_player_knocked_back(direction: Vector2):
	camera_2d.shake(direction.normalized(), normal_attack_screenshake_amount)


func _on_freeze_frame_timer_timeout() -> void:
	if freeze_frame_tween:
		freeze_frame_tween.kill()
		freeze_frame_tween = null
	
	get_tree().paused = false
	camera_2d.shake(screenshake_dir, screenshake_amount)


func _on_player_hit_as_boss(force: Vector2):
	freeze_frame(heavy_attack_freeze_frame_duration)
	screenshake_dir = force.normalized()
	screenshake_amount = heavy_attack_screenshake_amount


func _on_player_1_joined(source: Player) -> void:
	var tween_y = create_tween()
	tween_y.set_ease(Tween.EASE_OUT)
	tween_y.set_trans(Tween.TRANS_SINE)
	tween_y.tween_property(source, "global_position:y", player_1_spawn.global_position.y - spawn_in_jump_height, spawn_in_duration/2)
	tween_y.set_ease(Tween.EASE_IN)
	tween_y.set_trans(Tween.TRANS_SINE)
	tween_y.tween_property(source, "global_position:y", player_1_spawn.global_position.y,  spawn_in_duration/2)
	var tween_x = create_tween()
	tween_x.set_ease(Tween.EASE_OUT)
	tween_x.set_trans(Tween.TRANS_SINE)
	tween_x.tween_property(source, "global_position:x", player_1_spawn.global_position.x, spawn_in_duration)
	tween_x.tween_callback(source.spawn_in)


func _on_player_2_joined(source: Player) -> void:
	var tween_y = create_tween()
	tween_y.set_ease(Tween.EASE_OUT)
	tween_y.set_trans(Tween.TRANS_SINE)
	tween_y.tween_property(source, "global_position:y", player_2_spawn.global_position.y - spawn_in_jump_height, spawn_in_duration/2)
	tween_y.set_ease(Tween.EASE_IN)
	tween_y.set_trans(Tween.TRANS_SINE)
	tween_y.tween_property(source, "global_position:y", player_2_spawn.global_position.y,  spawn_in_duration/2)
	var tween_x = create_tween()
	tween_x.set_ease(Tween.EASE_OUT)
	tween_x.set_trans(Tween.TRANS_SINE)
	tween_x.tween_property(source, "global_position:x", player_2_spawn.global_position.x, spawn_in_duration)
	tween_x.tween_callback(source.spawn_in)


func _on_player_3_joined(source: Player) -> void:
	var tween_y = create_tween()
	tween_y.set_ease(Tween.EASE_OUT)
	tween_y.set_trans(Tween.TRANS_SINE)
	tween_y.tween_property(source, "global_position:y", player_3_spawn.global_position.y - spawn_in_jump_height, spawn_in_duration/2)
	tween_y.set_ease(Tween.EASE_IN)
	tween_y.set_trans(Tween.TRANS_SINE)
	tween_y.tween_property(source, "global_position:y", player_3_spawn.global_position.y,  spawn_in_duration/2)
	var tween_x = create_tween()
	tween_x.set_ease(Tween.EASE_OUT)
	tween_x.set_trans(Tween.TRANS_SINE)
	tween_x.tween_property(source, "global_position:x", player_3_spawn.global_position.x, spawn_in_duration)
	tween_x.tween_callback(source.spawn_in)


func _on_player_4_joined(source: Player) -> void:
	var tween_y = create_tween()
	tween_y.set_ease(Tween.EASE_OUT)
	tween_y.set_trans(Tween.TRANS_SINE)
	tween_y.tween_property(source, "global_position:y", player_4_spawn.global_position.y - spawn_in_jump_height, spawn_in_duration/2)
	tween_y.set_ease(Tween.EASE_IN)
	tween_y.set_trans(Tween.TRANS_SINE)
	tween_y.tween_property(source, "global_position:y", player_4_spawn.global_position.y,  spawn_in_duration/2)
	var tween_x = create_tween()
	tween_x.set_ease(Tween.EASE_OUT)
	tween_x.set_trans(Tween.TRANS_SINE)
	tween_x.tween_property(source, "global_position:x", player_4_spawn.global_position.x, spawn_in_duration)
	tween_x.tween_callback(source.spawn_in)

func on_player_won() -> void:
	bell_end.play()

#endregion
#region Regular Methods
func spawn_belt():
	belt_shadow_spawn_in.show()
	var tween_x = create_tween()
	tween_x.set_ease(Tween.EASE_IN)
	tween_x.set_trans(Tween.TRANS_SINE)
	tween_x.tween_property(belt, "global_position:y", 0, belt_spawn_duration)
	tween_x.tween_callback(func():
		belt_shadow_spawn_in.hide()
		belt.activate_collision()
		belt.is_active = true
	)
	var tween_shadow = create_tween()
	tween_shadow.set_ease(Tween.EASE_IN)
	tween_shadow.set_trans(Tween.TRANS_SINE)
	tween_shadow.tween_property(belt_shadow_spawn_in, "scale:x", 0.8, belt_spawn_duration)
	tween_shadow.parallel().tween_property(belt_shadow_spawn_in, "scale:y", 1, belt_spawn_duration)

	bell_start.play()

func hide_tutorial():
	tutorial.hide()


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
