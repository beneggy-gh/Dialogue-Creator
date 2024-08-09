class_name Dialogue 
extends Resource

var next_id: int
var text: String
var responses: Array

func to_json_readable() -> Dictionary:
	var dict = {}
	if responses.size() <= 0:
		dict = {
			"text": text,
			"next_id": next_id,
		}
	else:
		dict = {
			"text": text,
			"next_id": next_id,
			"responses": responses
		}
	return dict
