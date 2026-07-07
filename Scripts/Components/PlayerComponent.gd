class_name PlayerComponent
extends BaseComponent

var movement_component: MovementComponent

func ready() -> void:
	movement_component = actor_owner.get_component(MovementComponent.get_component_type())
func update(delta: float) -> void:
	var movement_input: Vector2 = Input.get_vector("left", "right", "up", "down")
	movement_component.move(movement_input)
