class_name PlayerComponent
extends BaseComponent

var movement_component: MovementComponent
var look_component: FPSLookComponent

func ready() -> void:
	movement_component = actor_owner.get_component(MovementComponent.get_component_type())
	movement_component = actor_owner.get_component(FPSLookComponent.get_component_type())
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: look_component.look(event.relative)
func update(delta: float) -> void:
	var movement_input: Vector2 = Input.get_vector("left", "right", "up", "down")
	movement_component.move(movement_input)
