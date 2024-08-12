@tool
extends GraphNode

var node_id = 0
var original_id = 0
var port
var type

# Called when the node enters the scene tree for the first time.
func _ready():
	port = get_input_port_slot(0)
	if type == 0:
		convert_to_exit()
	
	original_id = node_id
	$VBoxContainer/IDTypeSection/ID.value = node_id
	$VBoxContainer/IDTypeSection/Type.select(type)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_close_pressed():
	queue_free()

func _on_type_item_selected(index):
		var type = $VBoxContainer/IDTypeSection/Type.get_selected_id()
		if type == 0:
			convert_to_exit()
		else:
			print(type)
			convert_to_type()

func convert_to_exit():
	node_id = 0
	$VBoxContainer/IDTypeSection/ID.value = node_id
	$VBoxContainer/DialogueSection.visible = false
	self.set_slot_enabled_right(0, false)
	self.resizable = false
	self.size = Vector2(self.size.x, 125)

func convert_to_type():
	$VBoxContainer/IDTypeSection/ID.value = original_id
	$VBoxContainer/DialogueSection.visible = true
	self.size = Vector2(self.size.x, 285)
	self.set_slot_enabled_right(0, true)
