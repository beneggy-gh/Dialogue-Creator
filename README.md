# Dialogue-Creator - 0.2
> [!IMPORTANT]
> **This project is still under construction and may change between versions**

Used for personal projects mainly.

Create dialogue in JSON format per character.

Example:
```
{
	"1": {
		"next_id": 3,
		"responses": [
			{
				"next_id": 2,
				"required_item_name": "",
				"requires_item": false,
				"text": "Response 1"
			},
			{
				"next_id": 3,
				"required_item_name": "",
				"requires_item": false,
				"text": "Response 2"
			}
		],
		"text": "First message"
	},
	"4": {
		"next_id": 0,
		"text": "Reply to Response 2"
	}
}
```
