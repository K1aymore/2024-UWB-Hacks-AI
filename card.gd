extends Area2D
class_name Card

const WIDTH := 270

@export var title : String
@export var flavorText : String

@export var green : int
@export var water : int
@export var waterRequirement : int
@export var energyProduction : int


@export var type : TYPE

enum TYPE {
	PLANT,
	ANIMAL,
	WEATHER
}


func _ready() -> void:
	%Title.text = title
	%FlavorText.text = flavorText
	
	%EnergyCost.text = str(getEnergyCost())
	%WaterCost.text = str(waterRequirement)
	%GreenGeneration.text = str(green)
	%WaterCost.text = str(waterRequirement)
	
	match type:
		TYPE.PLANT:
			$Background.texture = load("res://CardArt/plant_template.png")
			%Generation.text = str(energyProduction)
		TYPE.ANIMAL:
			$Background.texture = load("res://CardArt/animal_template.png")
			%Generation.text = str(energyProduction)
		TYPE.WEATHER:
			$Background.texture = load("res://CardArt/weather_template.png")
			%Generation.text = str(water)
			%WaterCost.text = ""
	


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
