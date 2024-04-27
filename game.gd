extends Control

var cardScene = preload("res://card.tscn")
var textPopupScene = preload("res://text_popup.tscn")

var handMax := 5


const STARTING_ENERGY = 15
const STARTING_WATER = 20
const STARTING_TARGET_GREEN = 500

var energy := STARTING_ENERGY
var energyProduction := 0

var green := 0
var greenProduction := 0

var water := STARTING_WATER
var waterProduction := 0



var cardsPlayed : int
var maxRounds : int
var currentTurn : int
var targetGreen := STARTING_TARGET_GREEN

var levelNumber := 1


var city : CITY

enum CITY {
	Seattle,
	SanFrancisco,
	Austin,
	Miami,
	NewYork,
	Sahara,
}


signal wonLevel



func _ready() -> void:
	var startingCards := %StartingHand.get_children()
	startingCards.shuffle()
	for child in startingCards:
		addCard(child)
	



func newTurn():
	
	for i in range(handMax):
		if %Deck.get_child_count() == 0:
			# Shuffle discard
			var discardedCards = %Discard.get_children()
			discardedCards.shuffle()
			for child in discardedCards:
				child.reparent(%Deck)
		
		drawCard(%Deck.get_child(0))
	
	green += greenProduction
	energy += energyProduction
	water += waterProduction
	
	if water < 0:
		var waterDeficit = abs(water)
		greenProduction -= waterDeficit
		energyProduction -= waterDeficit / 3
		waterProduction += waterDeficit / 2
		water = 0
		energyProduction = 0 if energyProduction < 0 else energyProduction
		greenProduction = 0 if greenProduction < 0 else greenProduction
	
	if green > targetGreen:
		win()
	
	currentTurn += 1
	updateLabels()


func playCard(card : Card):
	
	if card.getEnergyCost() > energy:
		textPopup("Not enough energy")
		return
	
	if card.type == Card.TYPE.ANIMAL && card.water > water:
		textPopup("Not enough water")
		return
	
	match card.type:
		Card.TYPE.PLANT:
			waterProduction -= card.water
			greenProduction += card.green
			energyProduction += card.energy
		Card.TYPE.ANIMAL:
			water -= card.water
			green += card.green
		Card.TYPE.WEATHER:
			waterProduction += card.water
			greenProduction += card.green
	
	energy -= card.getEnergyCost()
	
	
	cardsPlayed += 1
	discardCard(card)
	updateLabels()
	
	if %Hand.get_child_count() == 0:
		newTurn()
	



func addCard(card : Card):
	card.reparent(%Deck)
	card.played.connect(playCard)
	card.recycled.connect(recycleCard)




func recycleCard(card : Card):
	energy += 1
	discardCard(card)

func discardCard(card : Card):
	card.reparent(%Discard)
	if %Hand.get_child_count() == 0:
		newTurn()
	updateLabels()


func drawCard(card : Card):
	card.reparent(%Hand)
	card.position = %Hand.STARTINGCARDPOS
	updateLabels()


func updateLabels():
	%TurnLabel.text = "Turn: " + str(currentTurn)
	%CardPlayedLabel.text = "Cards Played: "  + str(cardsPlayed)
	%LevelLabel.text = "Level: " + str(levelNumber)
	%TargetLabel.text = "Target Green: " + str(targetGreen)
	
	%EnergyLabel.text = str(energy)
	%EnergyProdLabel.text = str(energyProduction)
	%GreenLabel.text = str(green)
	%GreenProdLabel.text = str(greenProduction)
	%WaterLabel.text = str(water)
	%WaterProdLabel.text = str(waterProduction)
	
	
	$Background.modulate.a = green / float(targetGreen)




func textPopup(text : String):
	var textPopup : TextPopup = textPopupScene.instantiate()
	textPopup.text = text
	textPopup.position = get_local_mouse_position()
	add_child(textPopup)
	
	%Camera2D.shake()
	
	$VineBoom.play()


func _on_end_turn_button_pressed() -> void:
	$DrawSound.play()
	for child in %Hand.get_children():
		recycleCard(child)
		


func resetDeck():
	for child in %Hand.get_children():
		child.reparent(%Discard)
	
	for child in %Deck.get_children():
		child.reparent(%Discard)
	
	var cards = %Discard.get_children()
	cards.shuffle()
	for card in cards:
		card.reparent(%Deck)



func win():
	%WinLabel.text = "You beat " + CITY.keys()[levelNumber - 1]
	$WinMessage.show()


func _on_win_button_pressed() -> void:
	levelNumber += 1
	wonLevel.emit()


func newLevel():
	resetDeck()
	
	energy = STARTING_ENERGY
	energyProduction = 0
	green = 0
	greenProduction = 0
	water = STARTING_WATER
	waterProduction = 0
	
	cardsPlayed = 0
	currentTurn = 0
	
	targetGreen = STARTING_TARGET_GREEN * levelNumber
	
	$Background.texture = load("res://CityArt/" + str(CITY.keys()[levelNumber - 1]).to_lower() + ".jpg")
	
	$WinMessage.hide()
	
	newTurn()



func _on_store_card_added(card: Card) -> void:
	resetDeck()
	%Deck.get_child(0).free()
	resetDeck()
	
	addCard(card)
	newLevel()


