class_name NetworkTransformComponent
extends BaseComponent

@export var target_node: Node3D

var network_component: NetworkComponent

var _raw_position: Vector3 = Vector3.ZERO
var _raw_rotation: Basis
var _raw_scale: Vector3 = Vector3.ONE

var raw_position: Vector3:
	get: return _raw_position
	set(value): set_raw_position(value)
var raw_rotation: Basis:
	get: return _raw_rotation
	set(value): set_raw_rotation(value)
var raw_scale: Vector3 = Vector3.ONE:
	get: return _raw_scale
	set(value): set_raw_scale(value)

func ready():
	network_component = actor_owner.get_component(NetworkComponent.get_component_type())

func update(delta: float) -> void:
	if GLOBAL_NetworkManager.is_server():
		_raw_position = target_node.position
		_raw_rotation = target_node.global_basis
		_raw_scale = target_node.scale
	
static func get_component_type() -> String:
	return "NetworkTransformComponent"

func set_raw_position(value: Vector3) -> void:
	if not GLOBAL_NetworkManager.is_server():
		target_node.position = value
	_raw_position = value
func set_raw_rotation(value: Basis) -> void:
	if not GLOBAL_NetworkManager.is_server():
		target_node.global_basis = value
	_raw_rotation = value
func set_raw_scale(value: Vector3) -> void:
	if not GLOBAL_NetworkManager.is_server():
		target_node.scale = value
	_raw_scale = value
