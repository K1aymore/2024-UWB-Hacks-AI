extends Control

var handMax := 5

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
	updateLabels()


func playCard(card : Card):
	
	match card.type:
		Card.TYPE.PLANT:
			waterRequirement += card.waterRequirement
			greenGeneration += card.green
			energyGeneration += card.energyProduction
		Card.TYPE.ANIMAL:
			waterRequirement += card.waterRequirement
			green += card.green
		Card.TYPE.WEATHER:
			waterTotal += card.water
			greenGeneration += card.green
	
	energy -= card.getEnergyCost()
	
	cardsPlayed += 1
	discardCard(card)
	updateLabels()


func recycleCard(card : Card):
	card.recycled()
	discardCard(card)
	updateLabels()

func discardCard(card : Card):
	card.discarded()
	card.reparent(%Discard)
	updateLabels()

func drawCard(card : Card):
	card.drawn()
	card.reparent(%Hand)
	card.position = %Hand.STARTINGCARDPOS
	updateLabels()


func updateLabels():
	%TurnLabel.text = "Turn: " + str(currentTurn)
	%EnergyLabel.text = "Energy: " + str(energy)
	%GreenLabel.text = "Green: " + str(green)
	%WaterTotalLabel.text = "Water Total: " + str(waterTotal)
	%WaterRequirementLabel.text = "Water Requirement: " + str(waterRequirement)
