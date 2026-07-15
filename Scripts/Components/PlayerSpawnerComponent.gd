class_name PlayerSpawnerComponent
extends BaseComponent

@export var default_player: PackedScene

var network_spawner_component: NetworkSpawnerComponent

func ready() -> void:
	network_spawner_component = actor_owner.get_component(NetworkSpawnerComponent.get_component_type())
	
	GLOBAL_NetworkManager.client_connected.connect(on_client_connected)

func on_client_connected(client_id: int): 
	spawn_player(default_player, client_id)

func spawn_player(scene: PackedScene, client_id: int): 
	if not multiplayer.is_server(): return
	network_spawner_component.spawn_scene(scene, client_id)
	print("Spawned Player!!!!!!!!")

static func get_component_type() -> String:
	return "PlayerSpawnerComponent"
