class_name BaseComponent
extends Node

@export var is_enabled: bool = true
var actor_owner: Actor = null

func try_set_actor_owner(actor: Actor) -> bool:
	if actor_owner != null: return false
	actor_owner = actor
	return true

func init() -> void:
	pass
func ready() -> void:
	pass
func unhandled_input(event: InputEvent) -> void:
	pass
func update(delta: float) -> void:
	pass
func physics_update(delta: float) -> void:
	pass
func get_destroyed() -> void:
	pass

static func get_component_type() -> String:
	return "base"
