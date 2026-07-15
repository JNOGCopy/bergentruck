class_name PlayerComponent
extends BaseComponent

@export var client_side_nodes: Array[Node3D]
@export var camera: Camera3D

var movement_component: MovementComponent
var gravity_component: GravityComponent
var look_component: FPSLookComponent
var network_component: NetworkComponent

func ready() -> void:
	movement_component = actor_owner.get_component(MovementComponent.get_component_type())
	gravity_component = actor_owner.get_component(GravityComponent.get_component_type())
	look_component = actor_owner.get_component(FPSLookComponent.get_component_type())
	network_component = actor_owner.get_component(NetworkComponent.get_component_type())
	
	network_component.client_id_changed.connect(on_client_id_changed)
func unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: look_component.look(-event.relative)
	elif Input.is_action_pressed("jump"): gravity_component.jump()
func update(delta: float) -> void:
	var movement_input: Vector2 = Input.get_vector("left", "right", "up", "down")
	movement_component.move(movement_input)

static func get_component_type() -> String:
	return "PlayerComponent"

func on_client_id_changed(client_id: int):
	if not network_component.is_local_client():
		for i in client_side_nodes:
			i.hide()
		camera.current = false
	else:
		for i in client_side_nodes:
			i.show()
		camera.current = true
