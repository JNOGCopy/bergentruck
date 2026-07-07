class_name Actor
extends Node

const COMPONENTS_PATH: String = "ActorComponents"
var component_path_node: Node

@export var init_components: Array[BaseComponent]

var components_list: Array[BaseComponent]
var components_dictionary: Dictionary[String, Array]

var has_inited_components: bool = false

func _unhandled_input(event: InputEvent) -> void:
	for i in components_list:
		i.unhandled_input(event)

func _ready() -> void:
	component_path_node = find_child(COMPONENTS_PATH)
	if not component_path_node:
		component_path_node = Node.new()
		self.add_child(component_path_node)
	print(component_path_node.get_path())
	
	for i in init_components:
		add_component(i)
	for i in components_list:
		i.ready()
	has_inited_components = true

func _process(delta: float) -> void:
	for i in components_list:
		i.update(delta)

func _physics_process(delta: float) -> void:
	for i in components_list:
		i.physics_update(delta)

func get_component(type: String) -> BaseComponent:
	var component_type_list: Array = components_dictionary.get(type, null)
	
	if not component_type_list: return null
	if component_type_list.size() <= 0: return null
	
	var component_type_result: BaseComponent = component_type_list.back()
	
	if component_type_result: return component_type_result
	
	for i in components_list: if i.is_class(type): return i
	return null

func get_all_components(type: String) -> Array[BaseComponent]:
	var component_type_list: Array = components_dictionary.get(type, null)
	if not component_type_list: return component_type_list
	
	var output: Array[BaseComponent] = []
	for i in components_list: if i.is_class(type): output.append(i)
	
	return output

func add_component(component: BaseComponent) -> void:
	if not component.try_set_actor_owner(self): return
	components_list.append(component)
	
	if !components_dictionary.has(component.get_component_type()):
		components_dictionary[component.get_component_type()] = []
	
	var component_type_list: Array = components_dictionary.get(component.get_component_type())
	component_type_list.append(component)
	
	component.reparent(component_path_node)
	component.init()
	if has_inited_components: component.ready()

func remove_component(component: BaseComponent) -> void:
	components_list.erase(component)
	if !components_dictionary.has(component.get_component_type()): return
	var component_type_list: Array = components_dictionary.get(component.get_component_type())
	component_type_list.erase(component)

func has_component(type: String):
	var component_type_list: Array = components_dictionary.get(type)
	if component_type_list == null: return
