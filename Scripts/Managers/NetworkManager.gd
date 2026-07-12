class_name NetworkManager
extends Node

signal updated_client_list

signal connected_to_server
signal disconnected_from_server

signal client_connected(client_id: int)
signal client_disconnected(client_id: int)

var _client_list: Array[int]
var clients_list: Array[int]:
	get: return _client_list
	set(value): 
		_client_list = value
		updated_client_list.emit()

func _ready() -> void:
	multiplayer.connected_to_server.connect(on_connected_to_server)
	multiplayer.server_disconnected.connect(on_disconnected_from_server)
	multiplayer.peer_connected.connect(on_client_connected)
	multiplayer.peer_disconnected.connect(on_client_disconnected)

func join_server(ip: String, port: int) -> bool:
	if is_connected_to_server(): return false
	
	var peer = ENetMultiplayerPeer.new()
	if peer.create_client(ip, port): return false
	multiplayer.multiplayer_peer = peer
	print("join server")
	return true
func create_server(port: int) -> bool:
	if is_connected_to_server(): return false
	
	var peer = ENetMultiplayerPeer.new()
	if peer.create_server(port): return false
	multiplayer.multiplayer_peer = peer
	print("create server")
	return true
func host_server(port: int) -> bool:
	if not create_server(port): return false
	multiplayer.connected_to_server.emit()
	multiplayer.peer_connected.emit(multiplayer.get_unique_id())
	return true

func disconnect_from_server() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	on_disconnected_from_server()
func is_connected_to_server() -> bool:
	return not (multiplayer.multiplayer_peer is OfflineMultiplayerPeer)

func on_connected_to_server() -> void:
	print("You joined lol")
	#if not multiplayer.is_server(): clients_list.append(multiplayer.get_unique_id())
	connected_to_server.emit()
func on_disconnected_from_server() -> void:
	disconnected_from_server.emit()
	clients_list = []

func on_client_connected(client_id: int) -> void:
	if multiplayer.is_server(): clients_list.append(client_id)
	client_connected.emit(client_id)
func on_client_disconnected(client_id: int) -> void:
	if multiplayer.is_server(): clients_list.erase(client_id)
	client_disconnected.emit(client_id)
