class_name NetworkComponent
extends BaseComponent

signal client_id_changed(client_id: int)

@export var multiplayer_syncronizer: MultiplayerSynchronizer
var _client_id: int = 1
var client_id: int:
	get: return _client_id
	set(value): set_client_id(value)

func _ready() -> void:
	set_multiplayer_authority(1)
	multiplayer_syncronizer.set_multiplayer_authority(1)

func get_client_id() -> int: return client_id
func set_client_id(id: int) -> void: 
	print("Setted client id " + str(id))
	_client_id = id
	client_id_changed.emit(id)

func is_local_client() -> bool: 
	return client_id == multiplayer.get_unique_id()
func is_server() -> bool: return multiplayer.is_server()

static func get_component_type() -> String:
	return "NetworkComponent"
