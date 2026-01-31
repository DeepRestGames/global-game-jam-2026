class_name AudienceMember
extends Sprite2D

#region Signals
#endregion
#region Enums
#endregion
#region Constants
#endregion
#region Static Variables
#endregion
#region @export Variables
@export_group("Animation")
@export var idle_body_animation_movement_vector: Vector2 = Vector2(0, 5)
@export var idle_body_animation_cycle_duration: float = .6
@export var idle_hands_animation_movement_vector: Vector2 = Vector2(0, 8)
@export var idle_hands_animation_cycle_duration: float = .8
@export var animation_cycle_duration_modifier: float = .5

#endregion
#region Regular Variables
var movement_cycle_duration_multiplier
var body_tween: Tween
var hands_tween: Tween

#endregion
#region @onready Variables
@onready var body_sprite = self
@onready var hands_sprite: Sprite2D = $Hands
#endregion

#region Event Methods
#endregion
#region Signal Handlers
#endregion
#region Regular Methods
func _ready() -> void:
	hands_sprite.flip_h = randi_range(0, 1)
	CrowdManager.connect("update_engagement_value", update_animation)


func update_animation(engagement_value: float) -> void:
	print(engagement_value)
	
	movement_cycle_duration_multiplier = randf_range(engagement_value - animation_cycle_duration_modifier, engagement_value + animation_cycle_duration_modifier)
	movement_cycle_duration_multiplier = clampf(movement_cycle_duration_multiplier, 0.2, 10)

	if body_tween != null:
		body_tween.kill()
	body_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_loops()
	body_tween.tween_property(body_sprite, "offset", -idle_body_animation_movement_vector, idle_body_animation_cycle_duration / movement_cycle_duration_multiplier)
	body_tween.chain().tween_property(body_sprite, "offset", idle_body_animation_movement_vector, idle_body_animation_cycle_duration / movement_cycle_duration_multiplier)
	
	if hands_tween != null:
		hands_tween.kill()
	hands_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).set_loops()
	hands_tween.tween_property(hands_sprite, "offset", -idle_hands_animation_movement_vector, idle_hands_animation_cycle_duration / movement_cycle_duration_multiplier)
	hands_tween.chain().tween_property(hands_sprite, "offset", idle_hands_animation_movement_vector, idle_hands_animation_cycle_duration / movement_cycle_duration_multiplier)

#endregion
