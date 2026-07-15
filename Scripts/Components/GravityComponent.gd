class_name GravityComponent
extends BaseComponent 

@export var character_body: CharacterBody3D
@export var gravity_force: float = 9.81
@export var jump_force: float = 5
var gravity_velocity: float = 0

var network_component: NetworkComponent

func ready() -> void:
	network_component = actor_owner.get_component(NetworkComponent.get_component_type())

func update(delta: float) -> void:
	if character_body.is_on_floor() and gravity_velocity < 0:
		gravity_velocity = 0
	else:
		gravity_velocity -= gravity_force * delta
	
	character_body.velocity.y = gravity_velocity
	character_body.move_and_slide()

func jump():
	if not network_component.is_local_client(): return
	if network_component.is_server(): _apply_jump()
	else: 
		_apply_jump()
		CLIENT_RPC__request_jump.rpc_id(1)

@rpc("any_peer", "call_remote", "unreliable")
func CLIENT_RPC__request_jump() -> void:
	if not network_component.is_server(): return
	_apply_jump()

func _apply_jump():
	if character_body.is_on_floor(): gravity_velocity = jump_force

static func get_component_type() -> String:
	return "GravityComponent"
