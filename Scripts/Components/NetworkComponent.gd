class_name NetworkComponent
extends BaseComponent

@export var multiplayer_syncronizer: MultiplayerSynchronizer
var client_id: int = 1

func _ready() -> void:
	set_multiplayer_authority(1)
	multiplayer_syncronizer.set_multiplayer_authority(1)

func get_client_id() -> int: return client_id
func set_client_id(id: int) -> void: 
	if multiplayer.is_server(): client_id = id

func is_local_client() -> bool: 
	return client_id == multiplayer.get_unique_id()
func is_server() -> bool: return multiplayer.is_server()

static func get_component_type() -> String:
	return "NetworkComponent"
