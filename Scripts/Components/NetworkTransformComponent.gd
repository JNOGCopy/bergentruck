class_name NetworkTransformComponent
extends BaseComponent

@export var target_node: Node3D

@export var position_error_margin: float = 0.1
@export var position_lerp: float = 0.2

@export var rotation_error_margin: float = 0.02
@export var rotation_lerp: float = 0.2

var network_component: NetworkComponent

var _target_position: Vector3
var _target_rotation: Basis
var _target_scale: Vector3 = Vector3.ONE

var target_position: Vector3:
	get: return _target_position
	set(value): _set_target_position(value)
var target_rotation: Basis:
	get: return _target_rotation
	set(value): _set_target_rotation(value)
var target_scale: Vector3:
	get: return _target_scale
	set(value): _set_target_scale(value)

func ready():
	network_component = actor_owner.get_component(NetworkComponent.get_component_type())

func update(delta: float) -> void:
	_target_position = target_node.position
	_target_rotation = target_node.basis
	_target_scale = target_node.scale
	
static func get_component_type() -> String:
	return "NetworkTransformComponent"

func _set_target_position(value: Vector3):
	_target_position = value
	
	if target_node.position.distance_to(value) > position_error_margin && network_component.is_local_client():
		target_node.position = target_node.position.lerp(value, position_lerp)
	else:
		target_node.position = value
func _set_target_rotation(value: Basis):
	_target_rotation = value.orthonormalized()

	var target_q := _target_rotation.get_rotation_quaternion()
	var current_q := target_node.quaternion

	# Tomar el camino corto
	if current_q.dot(target_q) < 0.0:
		target_q = -target_q

	if network_component.is_local_client():
		if current_q.angle_to(target_q) > rotation_error_margin:
			target_node.quaternion = current_q.slerp(target_q, rotation_lerp).normalized()
		else:
			target_node.quaternion = target_q
	else:
		target_node.quaternion = target_q
func _set_target_scale(value: Vector3):
	_target_scale = value
	target_node.scale = value
