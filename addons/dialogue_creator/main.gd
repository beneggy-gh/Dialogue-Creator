@tool
extends Control

var dialogue_node = preload("res://addons/dialogue_creator/Nodes/node.tscn")
var option_button : OptionButton

var initial_position = Vector2(40,40)
@onready var node_index = 1

var lastSelectedNode
var lastSelectedPort
var lastOptionButtonPosition: Vector2

enum dialogue_types {EXIT, SAY, RESPONSE}
const EXIT = 0
const SAY = 1
const RESPONSE = 2

func _ready():
	print_tree_pretty()
	pass

func _process(delta):
	if option_button != null:
		if !option_button.has_focus():
			option_button.queue_free()

func _on_create_json_pressed():
	if $FileName.text == null or $FileName.text == "":
		printerr("Please enter a name for your dialogue file!")
		return
	var graph = $GraphEdit
	var connections = graph.get_connection_list()
	var response_nodes: Array
	var dict =  {}
	
	for i in range(0, connections.size()):
		var from_node = graph.get_node(connections[i].from_node as NodePath)
		var to_node = graph.get_node(connections[i].to_node as NodePath)
		
		var index = str(from_node.get_node('VBoxContainer/IDTypeSection/ID').value)
		var dialogue = Dialogue.new()
		
		## We run a check here to search for any stray Nodes 
		## that are not connected to anything or are not part
		## of the overall dialogue structure
		if to_node == null:
			if from_node.get_node('VBoxContainer/IDTypeSection/Type').get_selected_id() != 0 && connections.size() <= 1:
				printerr("Cannot save any information from ", from_node.get_node('VBoxContainer/IDTypeSection/ID').value, " because it is not connected to another node")
				continue
		
		## Check if node is an Exit node and if not grab the corresponding Say node info
		if from_node.get_node('VBoxContainer/IDTypeSection/Type').get_selected_id() == 0:
			dialogue.next_id = 0
		elif from_node.get_node('VBoxContainer/IDTypeSection/Type').get_selected_id() == 1:
			dialogue.text = graph.get_node(connections[i].from_node as NodePath).get_node('VBoxContainer/DialogueSection/Dialogue').text
			dialogue.next_id = graph.get_node(connections[i].to_node as NodePath).get_node('VBoxContainer/IDTypeSection/ID').value
		
		## ignore node if it is a Response
		elif from_node.get_node('VBoxContainer/IDTypeSection/Type').get_selected_id() == 2:
			continue
		
		## Create a Response node
		if to_node.get_node('VBoxContainer/IDTypeSection/Type').get_selected_id() == 2:
			response_nodes.append(to_node)
			for response_node in response_nodes:
				var response:= DialogueResponse.new()
				response.text = response_node.get_node('VBoxContainer/DialogueSection/Dialogue').text
				response.next_id = response_node.get_node('VBoxContainer/IDTypeSection/ID').value
				dialogue.responses.append(response.to_json_readable())
			response_nodes.clear()
		
		dict[index] = dialogue.to_json_readable()

	var json = JSON.new()
	
	## Save Dialogue into JSON
	var json_string = json.stringify(dict, "\t")
	var filename = str("res://",get_node("FileName").text, ".json")#
	print(filename)
	
	var file := FileAccess.open(filename, FileAccess.WRITE)
	file.store_line(json_string)

func _on_add_node_pressed(node_type, offset_position, auto_connect):
	var new_node = dialogue_node.instantiate()
	new_node.position = initial_position * node_index
	new_node.node_id = node_index
	new_node.type = node_type
	
	## Connect some buttons signals to some methods here
	var close_button : Button = new_node.get_node("Close")
	close_button.pressed.connect(Callable(self, "_on_node_closed"))
	var type_button : OptionButton = new_node.get_node("VBoxContainer/IDTypeSection/Type")
	type_button.item_selected.connect(self.on_node_type_change.bind(new_node)) 
	
	## Finish off by adding and incrementing
	$GraphEdit.add_child(new_node)
	node_index += 1

func _on_node_type_change(new_node):
	var type = new_node.get_node("$VBoxContainer/IDTypeSection/Type").get_selected_id()
	if type != 0:
		new_node.node_id = node_index
		node_index += 1

func _on_node_closed():
	node_index -= 1

func _on_new_option_focus_exited(button):
	queue_free()

func _on_newnode_type_item_selected(node_type, release_position):
	var new_node = dialogue_node.instantiate()
	if node_type == 0:
		new_node.node_id = 0
	else:
		new_node.node_id = node_index
		node_index += 1
	new_node.type = node_type
	if lastSelectedNode.get_node('VBoxContainer/IDTypeSection/Type').get_selected_id() == 2 && node_type == 2:
		printerr("Cannot connect Response Node to Response Node")
		option_button.queue_free()
		pass
	else:
		new_node.position_offset.x += new_node.size.x + 100
		new_node.position_offset.y += 100 * node_index
		var close_button : Button = new_node.get_node("Close")
		close_button.pressed.connect(Callable(self, "_on_node_closed"))
		$GraphEdit.add_child(new_node)
		$GraphEdit.connect_node(lastSelectedNode.name, lastSelectedPort, new_node.name, new_node.port)
		option_button.queue_free()

func _on_graph_edit_connection_to_empty(from_node, from_port, release_position):
	option_button = OptionButton.new()
	option_button.position = release_position
	lastOptionButtonPosition = release_position
	for type in dialogue_types:
		option_button.add_item(type)
	option_button.select(-1)
	option_button.text = "Type"
	option_button.item_selected.connect(self._on_newnode_type_item_selected.bind(release_position))
	$GraphEdit.add_child(option_button)
	option_button.grab_focus()

func _on_graph_edit_connection_drag_started(from_node, from_port, is_output):
	if is_output:
		lastSelectedNode = $GraphEdit.get_node(from_node)
		lastSelectedPort = from_port

func _on_graph_edit_connection_request(from_node, from_port, to_node, to_port):
	if $GraphEdit.get_node(str(from_node, '/VBoxContainer/IDTypeSection/Type')).get_selected_id() == 2 && $GraphEdit.get_node(str(to_node, '/VBoxContainer/IDTypeSection/Type')).get_selected_id() == 2:
		printerr("Cannot connect Response Node to Response Node")
		pass
	else:
		$GraphEdit.connect_node(from_node, from_port, to_node, to_port)

func _on_graph_edit_disconnection_request(from_node, from_port, to_node, to_port):
	$GraphEdit.disconnect_node(from_node, from_port, to_node, to_port)


func _on_reset_counter_pressed():
	node_index = 1


func _on_load_json_pressed():
	var dialog = FileDialog.new()
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILES
	dialog.access = FileDialog.ACCESS_RESOURCES
	dialog.size = Vector2(650, 400)
	dialog.use_native_dialog = true
	dialog.file_selected.connect(load_json)
	
	add_child(dialog)
	dialog.popup_centered()
	
func load_json(file):
	var json = read_json(file[0])
	print(json)

func read_json(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var parsed_json = json.parse_string(content)
	print(parsed_json)
	return parsed_json
