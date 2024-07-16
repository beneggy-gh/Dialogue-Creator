@tool
extends Control

var dialogue_node = preload("res://addons/dialogue_creator/Nodes/node.tscn")
var option_button : OptionButton

var initial_position = Vector2(40,40)
var node_index = 1

var lastSelectedNode
var lastSelectedPort

enum dialogue_types {EXIT, SAY, RESPONSE}
const EXIT = 0
const SAY = 1
const RESPONSE = 2

func _ready():
	pass

func _process(delta):
	if option_button != null:
		if !option_button.has_focus():
			option_button.queue_free()

func _on_create_json_pressed():
	var graph = $GraphEdit
	var connections = graph.get_connection_list()
	var result = 0
	var dialogue = ""
	var next_id = 0
	var jsonDictionary =  {}
	for i in range(0, connections.size()):
		var id = graph.get_node(connections[i].from_node as NodePath).get_node('vBoxContainer/HBoxContainer/ID').value
		if graph.get_node(connections[i].from_node).get_node('vBoxContainer/HBoxContainer/Type').get_selected_id() == "0":
			next_id = 0
		if graph.get_node(connections[i].from_node).get_node('vBoxContainer/HBoxContainer/Type').get_selected_id() == "2":
			print("Response")
			print(graph.get_node(connections[i].to_node).get_node('vBoxContainer/VBoxContainer/Dialogue').text)
		else:
			dialogue = graph.get_node(connections[i].from_node).get_node('vBoxContainer/VBoxContainer/Dialogue').text			
			next_id = graph.get_node(connections[i].to).get_node('vBoxContainer/HBoxContainer/ID').value

func _on_add_node_pressed(node_type, offset_position, auto_connect):
	var new_node = dialogue_node.instantiate()
	new_node.position = initial_position
	new_node.node_id = node_index
	new_node.type = node_type
	$GraphEdit.add_child(new_node)
	if auto_connect:
		$GraphEdit.connect_node(lastSelectedNode, lastSelectedPort, new_node.name, new_node.port)
	node_index += 1

func _on_graph_edit_connection_to_empty(from_node, from_port, release_position):
	option_button = OptionButton.new()
	option_button.position = release_position
	for type in dialogue_types:
		option_button.add_item(type)
	option_button.select(-1)
	option_button.text = "Type"
	var setdown_position = release_position
	option_button.item_selected.connect(self._on_newnode_type_item_selected.bind(setdown_position))
	$GraphEdit.add_child(option_button)
	option_button.grab_focus()
	
func _on_new_option_focus_exited(button):
	queue_free()
	
func _on_newnode_type_item_selected(node_type, release_position):
	var new_node = dialogue_node.instantiate()
	new_node.position = release_position
	new_node.node_id = node_index
	new_node.type = node_type
	$GraphEdit.add_child(new_node)
	$GraphEdit.connect_node(lastSelectedNode, lastSelectedPort, new_node.name, new_node.port)
	node_index += 1
	option_button.queue_free()

func _on_graph_edit_connection_drag_started(from_node, from_port, is_output):
	if is_output:
		lastSelectedNode = from_node
		lastSelectedPort = from_port

func _on_graph_edit_connection_request(from_node, from_port, to_node, to_port):
	$GraphEdit.connect_node(from_node, from_port, to_node, to_port)

func _on_graph_edit_disconnection_request(from_node, from_port, to_node, to_port):
	$GraphEdit.disconnect_node(from_node, from_port, to_node, to_port)



