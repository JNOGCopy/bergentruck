class_name MovementComponent
extends BaseComponent

@export var character_body: CharacterBody3D
@export var rotator: Node3D

@export var speed: float = 4.0
@export var acceleration: float = 4.0

var current_movement_input: Vector2 = Vector2.ZERO
var current_movement_velocity: Vector3 = Vector3.ZERO

func physics_update(delta: float) -> void:
	var velocity = lerp(current_movement_velocity, rotator.basis * Vector3(current_movement_input.x, 0, current_movement_input.y) * speed, delta * acceleration)
	character_body.velocity = velocity
	character_body.move_and_slide()
	print(velocity)
	current_movement_input = Vector2.ZERO
	current_movement_velocity = velocity

func move(input: Vector2):
	current_movement_input = input.normalized()

static func get_component_type() -> String:
	return "MovementComponent"
