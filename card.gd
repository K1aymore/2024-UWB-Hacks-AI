extends Area2D
class_name Card

const WIDTH := 200

@export var title : String
@export var flavorText : String

@export var green : int
@export var water : int
@export var waterRequirement : int
@export var energyProduction : int


@export var type : TYPE

enum TYPE {
	FOREST,
	ANIMAL,
	WEATHER
}


func getEnergyCost() -> int:
	var cost := green + water + energyProduction
	
	if type == TYPE.ANIMAL:
		cost -= waterRequirement
	
	return cost


func recycled():
	pass

func discarded():
	pass

func drawn():
	pass
