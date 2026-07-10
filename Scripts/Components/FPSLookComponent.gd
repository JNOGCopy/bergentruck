class_name FPSLookComponent
extends BaseComponent

@export var sensitivity: float = 1
@export var body_node: Node3D
@export var neck_node: Node3D

var roll_angle: float

func look(input: Vector2):
	var look_input: Vector2 = input * sensitivity
	body_node.rotate_y(deg_to_rad(look_input.x))
	roll_angle = clamp(roll_angle + deg_to_rad(look_input.y), deg_to_rad(-75), deg_to_rad(75))
	neck_node.rotation.x = roll_angle
	
	print(look_input)

static func get_component_type() -> String:
	return "FPSLookComponent"
