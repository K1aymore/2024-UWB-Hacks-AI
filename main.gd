extends Control

var handMax := 4

var energy : int
var energyMax : int
var energyGeneration : int

var waterTotal : int
var waterRequirement : int

var green : int
var greenGeneration : int



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
	
	green += greenGeneration
	energy += energyGeneration
	
	currentTurn += 1


func playCard(card : Card):
	
	match card.type:
		Card.TYPE.FOREST:
			waterTotal += card.water
			waterRequirement += card.waterRequirement
			greenGeneration += card.green
			energyGeneration += card.energyProduction
		Card.TYPE.ANIMAL:
			green += card.green
		Card.TYPE.WEATHER:
			waterTotal += card.water
			greenGeneration += card.green
	
	energy -= card.getEnergyCost()
	
	cardsPlayed += 1
	discardCard(card)


func recycleCard(card : Card):
	card.recycled()
	discardCard(card)

func discardCard(card : Card):
	card.discarded()
	card.reparent(%Discard)

func drawCard(card : Card):
	card.drawn()
	card.reparent(%Hand)
	card.position = %Hand.STARTINGCARDPOS
