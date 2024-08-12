# Dialogue-Creator
> [!IMPORTANT]
> **This project is still under construction and may change between versions**

Used for personal projects mainly.

Create dialogue in JSON format per character.

Example:
```
{
	"1": {
		"NextId": 2,
		"Text": "Hello Adventurer!",
		"Responses": null
	},
	"2": {
		"NextId": 0,
		"Text": "What is your name?",
		"Responses": [
			{
				"Text": "I'm not telling you!",
				"Type": {
					"value__": 1
				},
				"NextId": 0
			},
			{
				"Text": "My name is {PLAYER_NAME}",
				"Type": {
					"value__": 0
				},
				"NextId": 3
			}
		]
	},
	"3": {
		"NextId": 0,
		"Text": "Well met, {PLAYER_NAME}!",
		"Responses": null		
	}
}
```
