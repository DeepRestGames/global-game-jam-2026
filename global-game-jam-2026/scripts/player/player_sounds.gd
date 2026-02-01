class_name PlayerSounds
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
@export var hurt_sfx_pitch_small: float = 1.0
@export var hurt_sfx_pitch_boss: float = .7
#endregion
#region Regular Variables
#endregion
#region @onready Variables
@onready var player: Player = $".."
@onready var punch_miss: AudioStreamPlayer = $PunchMiss
@onready var punch_miss_boss: AudioStreamPlayer = $PunchMissBoss
@onready var punch_hit: AudioStreamPlayer = $PunchHit
@onready var punch_hit_boss: AudioStreamPlayer = $PunchHitBoss
@onready var hurt: AudioStreamPlayer = $Hurt
@onready var mask_get: AudioStreamPlayer = $MaskGet
@onready var mask_lose: AudioStreamPlayer = $MaskLose
#endregion

#region Event Methods
#endregion
#region Signal Handlers

func on_attacked() -> void:
	await get_tree().create_timer(.05).timeout
	if punch_hit.playing or punch_hit_boss.playing:
		return
	
	if player._is_boss:
		punch_miss_boss.play()
	else:
		punch_miss.play()

func on_hit() -> void:
	punch_hit.play()

func on_hit_as_boss() -> void:
	punch_hit_boss.play()

func on_knocked_back() -> void:
	if player._is_boss:
		hurt.pitch_scale = hurt_sfx_pitch_boss
	else:
		hurt.pitch_scale = hurt_sfx_pitch_small
	hurt.play()

func on_upgraded() -> void:
	mask_get.play()

func on_downgraded() -> void:
	mask_lose.play()


#endregion
#region Regular Methods

func _ready() -> void:
	player.attacked.connect(on_attacked)
	player.hit.connect(on_hit.unbind(1))
	player.hit_as_boss.connect(on_hit_as_boss.unbind(1))
	player.knocked_back.connect(on_knocked_back.unbind(1))
	player.upgraded.connect(on_upgraded.unbind(1))
	player.downgraded.connect(on_downgraded.unbind(1))

#endregion
