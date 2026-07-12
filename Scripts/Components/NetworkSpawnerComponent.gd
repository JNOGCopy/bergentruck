class_name NetworkSpawnerComponent
extends BaseComponent

@export var multiplayer_spawner: MultiplayerSpawner

func spawn_scene(scene: PackedScene, client_id: int) -> void:
	if not multiplayer.is_server(): return
	var node = scene.instantiate()
	get_node(multiplayer_spawner.spawn_path).add_child(node)
	
	if node is Actor:
		if node.has_component(NetworkComponent.get_component_type()):
			(node.get_component(NetworkComponent.get_component_type()) as NetworkComponent).set_client_id(client_id)
			return
	
	node.set_multiplayer_authority(client_id)
