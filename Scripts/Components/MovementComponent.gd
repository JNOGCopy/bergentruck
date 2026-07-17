class_name MovementComponent
extends BaseComponent

@export var character_body: CharacterBody3D
@export var rotator: Node3D

@export var speed: float = 4.0
@export var acceleration: float = 4.0

var current_movement_input: Vector2 = Vector2.ZERO
var current_movement_velocity: Vector3 = Vector3.ZERO

var network_component: NetworkComponent

class ClientMovementData:
	var tick: int
	var position: Vector3

func ready() -> void:
	network_component = actor_owner.get_component(NetworkComponent.get_component_type())

func physics_update(delta: float) -> void:
	if !(network_component.is_local_client() or network_component.is_server()): return
	
	var velocity = lerp(current_movement_velocity, rotator.basis * Vector3(current_movement_input.x, 0, current_movement_input.y) * speed, delta * acceleration)
	character_body.velocity = velocity
	character_body.move_and_slide()
	current_movement_input = Vector2.ZERO
	current_movement_velocity = velocity

func move(input: Vector2):
	if not network_component.is_local_client(): return
	if network_component.is_server(): _apply_movement(input)
	else: 
		_apply_movement(input)
		CLIENT_RPC__request_jump.rpc_id(1, input)

@rpc("any_peer", "call_remote", "unreliable")
func CLIENT_RPC__request_jump(input: Vector2) -> void:
	if not network_component.is_server(): return
	_apply_movement(input)
func _apply_movement(input: Vector2) -> void:
	current_movement_input = input.normalized()

static func get_component_type() -> String:
	return "MovementComponent"
