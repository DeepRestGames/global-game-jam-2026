extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@onready var player_input = $PlayerInput


func _ready() -> void:
	player_input.connect("player_movement", player_movement)
	player_input.connect("player_punch", player_punch)


func player_movement(movement_direction: Vector2) -> void:
	velocity = movement_direction * SPEED


func player_punch() -> void:
	print("Player punch!")


func _physics_process(delta: float) -> void:
	move_and_slide()
