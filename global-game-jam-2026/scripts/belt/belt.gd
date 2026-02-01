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
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var shadow_sprite_2d: Sprite2D = $ShadowSprite2D
@onready var bump: AudioStreamPlayer = $Bump
#endregion

#region Event Methods
func _ready() -> void:
	animation_player.play("Idle")
#endregion
#region Signal Handlers
func _on_body_entered(body: Node2D) -> void:
	if !is_active: return
	
	if body is Player:
		body.upgrade_player()
		hide()
		animation_player.stop()
		is_active = false
#endregion
#region Regular Methods
func activate_collision():
	shadow_sprite_2d.show()
	collision_shape_2d.disabled = false

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
	
	await get_tree().create_timer(bounce_down_duration).timeout
	bump.play()
	
	await get_tree().create_timer(bounce_down_duration).timeout
	animation_player.play("Idle")
#endregion
