extends Control

var cardScene = preload("res://card.tscn")

var handMax := 5

var energy := 10
var energyProduction := 0

var green := 0
var greenProduction := 0

var water := 20
var waterProduction := 0



var cardsPlayed : int
var maxRounds : int
var currentTurn : int

var levelNumber : int


var city : CITY

enum CITY {
	SAHARA_DESERT,
	BOULDER_COLORADO,
}



func _ready() -> void:
	var startingCards := %StartingHand.get_children()
	startingCards.shuffle()
	for child in startingCards:
		addCard(child)
	
	newTurn()


func endTurn() -> void:
	newTurn()


func newTurn():
	for child in %Hand.get_children():
		recycleCard(child)
	
	for i in range(handMax):
		# Shuffle discard
		if %Deck.get_child_count() == 0:
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
	
	currentTurn += 1
	updateLabels()


func playCard(card : Card):
	
	if card.getEnergyCost() > energy:
		print("Not enough energy :(")
		return
	
	match card.type:
		Card.TYPE.PLANT:
			waterProduction += card.water
			greenProduction += card.green
			energyProduction += card.energy
		Card.TYPE.ANIMAL:
			water += card.water
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
	updateLabels()

func discardCard(card : Card):
	card.reparent(%Discard)
	updateLabels()

func drawCard(card : Card):
	card.reparent(%Hand)
	card.position = %Hand.STARTINGCARDPOS
	updateLabels()


func updateLabels():
	%TurnLabel.text = "Turn: " + str(currentTurn)
	%CardPlayedLabel.text = "Cards Played: "  + str(cardsPlayed)
	
	%EnergyLabel.text = str(energy)
	%EnergyProdLabel.text = str(energyProduction)
	%GreenLabel.text = str(green)
	%GreenProdLabel.text = str(greenProduction)
	%WaterLabel.text = str(water)
	%WaterProdLabel.text = str(waterProduction)




func generateCard():
	var card : Card = cardScene.instantiate()
	
	card.type = Card.TYPE.WEATHER
	card.water = -3
	card.energy = 1
	card.green = 2
	
	add_child(card)
	addCard(card)
