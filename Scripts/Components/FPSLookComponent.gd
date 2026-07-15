class_name FPSLookComponent
extends BaseComponent

var network_component: NetworkComponent

@export var sensitivity: float = 1
@export var body_node: Node3D
@export var neck_node: Node3D

var roll_angle: float

func ready() -> void:
	network_component = actor_owner.get_component(NetworkComponent.get_component_type())

func look(input: Vector2) -> void:
	if not network_component.is_local_client(): return
	
	if network_component.is_server(): apply_look(input)
	else:
		apply_look(input) 
		CLIENT_RPC__request_look.rpc_id(1, input)

@rpc("any_peer", "call_remote", "unreliable")
func CLIENT_RPC__request_look(input: Vector2) -> void:
	if not network_component.is_server(): return
	apply_look(input)

func apply_look(input: Vector2):
	var look_input: Vector2 = input * sensitivity
	body_node.rotate_y(deg_to_rad(look_input.x))
	roll_angle = clamp(roll_angle + deg_to_rad(look_input.y), deg_to_rad(-75), deg_to_rad(75))
	neck_node.rotation.x = roll_angle

static func get_component_type() -> String:
	return "FPSLookComponent"
