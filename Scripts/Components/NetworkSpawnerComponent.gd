class_name NetworkSpawnerComponent
extends BaseComponent

@export var multiplayer_spawner: MultiplayerSpawner
@export var players_node_parent: Node

func ready() -> void:
	GLOBAL_NetworkManager.client_disconnected.connect(on_client_disconnected)
	GLOBAL_NetworkManager.disconnected_from_server.connect(on_disconnected_from_server)

func spawn_scene(scene: PackedScene, client_id: int) -> Node:
	if not GLOBAL_NetworkManager.is_server(): return
	
	var node = scene.instantiate()
	players_node_parent.add_child(node, true)
	
	if node is Actor:
		if node.has_component(NetworkComponent.get_component_type()):
			(node.get_component(NetworkComponent.get_component_type()) as NetworkComponent).set_client_id(client_id)
			print("🛜: Node has just spawned, it's ClientID owner is %s and it was setted with the component NetworkComponent" % [client_id])
			return node
	
	node.set_multiplayer_authority(client_id)
	print("🛜: Node has just spawned, it's ClientID owner is %s and it was setted with Godot's built in multiplayer because is not a Actor or NetworkComponent is missing" % [client_id])
	return node

func on_client_disconnected(client_id: int):
	if not GLOBAL_NetworkManager.is_server(): return
	
	var children := players_node_parent.get_children()
	
	for i in children:
		if i is Actor:
			var network_component = i.get_component(NetworkComponent.get_component_type()) as NetworkComponent
			if network_component != null:
				if network_component.get_client_id() == client_id:
					i.call_deferred("queue_free")
					print("🛜: Node %s that owns %s has just been deleted" % [i.name, client_id])
					break
		if i.get_multiplayer_authority() == client_id:
			i.call_deferred("queue_free")
			print("🛜: Node %s that owns %s has just been deleted" % [i.name, str(client_id)])

func on_disconnected_from_server() -> void:
	var children := players_node_parent.get_children()
	
	for i in children:
		i.call_deferred("queue_free")
	
	print("🛜: All network nodes were destroyed because player has just leave the server")

static func get_component_type() -> String:
	return "NetworkSpawnerComponent"
