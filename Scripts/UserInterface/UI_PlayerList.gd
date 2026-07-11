class_name UI_ClientList
extends ItemList

func _ready() -> void:
	GLOBAL_NetworkManager.connected_to_server.connect(on_connected_to_server)
	GLOBAL_NetworkManager.disconnected_from_server.connect(on_disconnected_from_server)
	GLOBAL_NetworkManager.client_connected.connect(on_client_connected)
	GLOBAL_NetworkManager.client_disconnected.connect(on_client_disconnected)
	GLOBAL_NetworkManager.updated_client_list.connect(on_updated_client_list)

func on_updated_client_list() -> void:
	reload_list()
func on_connected_to_server() -> void:
	reload_list()
func on_disconnected_from_server() -> void:
	reload_list()
func on_client_connected(client_id: int) -> void:
	reload_list()
func on_client_disconnected(client_id: int) -> void:
	reload_list()

func reload_list() -> void:
	clear()
	for i in GLOBAL_NetworkManager.clients_list:
		add_item(("YOU: " if multiplayer.get_unique_id() == i else "") + str(i))
