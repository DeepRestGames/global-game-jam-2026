class_name PlayerCorner
extends Area2D

#region Signals
signal player_entered
#endregion
#region Enums
#endregion
#region Constants
#endregion
#region Static Variables
#endregion
#region @export Variables
@export var player: Player
#endregion
#region Regular Variables
var is_player_inside = false
#endregion
#region @onready Variables
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
#endregion

#region Event Methods
func _ready():
	sprite_2d.modulate = player.player_color
#endregion
#region Signal Handlers
func disable_collision():
	_disable_collision_callable.call_deferred()


func _disable_collision_callable():
	collision_shape_2d.disabled = true


func _on_body_entered(body: Node2D) -> void:
	if body == player:
		is_player_inside = true
		player_entered.emit()


func _on_body_exited(body: Node2D) -> void:
	if body == player: is_player_inside = false
#endregion
#region Regular Methods
#endregion
