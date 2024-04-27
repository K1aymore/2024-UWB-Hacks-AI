extends Control

var cardScene := preload("res://card.tscn")

var cardTitle : String


signal cardAdded(card : Card)



func _on_line_edit_text_submitted(new_text: String) -> void:
	generateCard(new_text)


func generateCard(title : String):
	cardTitle = title
	
	var key_file = FileAccess.open("res://chatgpt-api-key.txt", FileAccess.READ)
	var api_key := key_file.get_line()
	print(api_key)
	
	var url : String = "https://api.openai.com/v1/chat/completions"
	var temperature : float = 0.5
	var max_tokens : int = 1024
	var headers = ["Content-type: application/json", "Authorization: Bearer " + api_key]
	var model : String = "gpt-3.5-turbo"
	var messages = []
	var request := HTTPRequest.new()
	add_child(request)
	
	messages.append({
		"role": "user",
		"content": "Generate a card with the name \"" + title + "\". Choose a type of either PLANT, ANIMAL, or WEATHER. Generate flavor text for the card, with a max length of 170 characters. Based on the flavor text, give it numbers for the attributes \"Green\", \"Water\", and \"Energy\". Give your results as a list.title"
	})
	
	var body = JSON.new().stringify({
		"messages": messages,
		"temperature": temperature,
		"max_tokens": max_tokens,
		"model": model
	})
	
	request.connect("request_completed", _on_request_completed)
	var send_request = request.request(url, headers, HTTPClient.METHOD_POST, body)
	

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	print(json)
	var response = json.get_data()
	print(response)
	var message : String = response["choices"][0]["message"]["content"]
	print(message)
	
	var card : Card = cardScene.instantiate()
	
	card.title = cardTitle
	
	var plantStart = message.findn("plant")
	print("Plant start: ", plantStart)
	var animalStart = message.findn("animal")
	print("Animal start: ", animalStart)
	var weatherStart = message.findn("weather")
	print("Weather start: ", weatherStart)
	
	
	if plantStart != -1:
		card.type = Card.TYPE.PLANT
	if animalStart != -1:
		card.type = Card.TYPE.ANIMAL
	if weatherStart != -1:
		card.type = Card.TYPE.WEATHER
	
	print(card.type)
	
	var attributeStart = message.findn("attributes:")
	var flavorTextStart := message.findn("flavor text: ") + 13
	card.flavorText = message.substr(flavorTextStart, attributeStart-flavorTextStart)
	
	print("Green number:")
	print(int(message.substr(message.findn("green:", attributeStart) + 6, 3)))
	
	card.green = int(message.substr(message.findn("green:", attributeStart) + 7, 1))
	card.water = int(message.substr(message.findn("water:", attributeStart) + 7, 1))
	card.energy = int(message.substr(message.findn("energy:", attributeStart) + 8, 1))
	
	
	var currentLevel : int = %Game.levelNumber
	
	card.green *= currentLevel
	card.energy *= currentLevel
	
	if card.type == Card.TYPE.WEATHER:
		card.water *= currentLevel
	
	card.level = currentLevel
	
	add_child(card)
	cardAdded.emit(card)



