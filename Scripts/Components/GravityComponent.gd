class_name GravityComponent
extends BaseComponent 

@export var character_body: CharacterBody3D
@export var gravity_force: float = 9.81
var current_velocity: float = 0

func update(delta: float) -> void:
	if character_body.is_on_floor() and current_velocity < 0:
		current_velocity = 0
	else:
		current_velocity -= gravity_force * delta
	
	character_body.velocity.y = current_velocity
	character_body.move_and_slide()
