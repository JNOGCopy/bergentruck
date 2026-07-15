class_name NetworkTransformComponent
extends BaseComponent

@export var target_node: Node3D

var network_component: NetworkComponent

var raw_position: Vector3
var raw_rotation: Basis
var raw_scale: Vector3 = Vector3.ONE

func ready():
	network_component = actor_owner.get_component(NetworkComponent.get_component_type())

func update(delta: float) -> void:
	if not GLOBAL_NetworkManager.is_server():
		target_node.position = target_node.position.lerp(raw_position, delta * 10)
		target_node.global_basis = raw_rotation
		target_node.scale = raw_scale
	
	raw_position = target_node.position
	raw_rotation = target_node.global_basis
	raw_scale = target_node.scale
	
static func get_component_type() -> String:
	return "NetworkTransformComponent"
