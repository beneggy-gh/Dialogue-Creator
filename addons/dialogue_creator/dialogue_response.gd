class_name DialogueResponse
extends Resource

var text: String
var next_id: int
var requires_item: bool
var required_item_name: String

func to_json_readable() -> Dictionary:
	var dict = {
		"text": text,
		"next_id": next_id,
		"requires_item": requires_item,
		"required_item_name": required_item_name
	}
	return dict
