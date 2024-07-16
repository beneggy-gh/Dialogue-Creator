@tool
extends GraphNode

var node_id = 0
var port
var type

# Called when the node enters the scene tree for the first time.
func _ready():
	port = get_input_port_slot(0)
	if type == 0:
		node_id = 0
		$vBoxContainer/VBoxContainer.queue_free()
		self.set_slot_enabled_right(0, false)
		self.resizable = false
		self.size = Vector2(self.size.x, 125)
		

	$vBoxContainer/HBoxContainer/ID.value = node_id
	$vBoxContainer/HBoxContainer/Type.select(type)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_pressed():
	queue_free()

func _on_type_item_selected(index):
		var type = $vBoxContainer/HBoxContainer/Type.get_selected_id()
		if type == 0:
			node_id = 0
			$vBoxContainer/HBoxContainer/ID.value = node_id
