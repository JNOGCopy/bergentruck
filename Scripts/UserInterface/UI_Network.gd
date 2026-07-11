class_name UI_Network
extends Node

@export var ip_input_field: LineEdit
@export var port_input_field: LineEdit

@export var join_server_button: BaseButton
@export var create_server_button: BaseButton
@export var host_server_button: BaseButton
@export var disconnect_server_button: BaseButton

func _ready() -> void:
	join_server_button.pressed.connect(on_join_server_button_pressed)
	create_server_button.pressed.connect(on_create_server_button_pressed)
	host_server_button.pressed.connect(on_host_server_button_pressed)
	disconnect_server_button.pressed.connect(on_disconnect_server_button_pressed)

func on_join_server_button_pressed():
	GLOBAL_NetworkManager.join_server(ip_input_field.text, int(port_input_field.text))
func on_create_server_button_pressed():
	GLOBAL_NetworkManager.create_server(int(port_input_field.text))
func on_host_server_button_pressed():
	GLOBAL_NetworkManager.host_server(int(port_input_field.text))
func on_disconnect_server_button_pressed():
	GLOBAL_NetworkManager.disconnect_from_server()
