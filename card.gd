extends Area2D
class_name Card

const WIDTH := 270

@export var title : String
@export var flavorText : String

@export var green : int
@export var water : int
@export var waterProduction : int
@export var energyProduction : int


@export var type : TYPE

enum TYPE {
	PLANT,
	ANIMAL,
	WEATHER
}


signal played(card : Card)
signal recycled(card : Card)



func _ready() -> void:
	%Title.text = title
	%FlavorText.text = flavorText
	
	%EnergyCost.text = str(getEnergyCost())
	%WaterCost.text = str(waterProduction)
	%GreenGeneration.text = str(green)
	%WaterCost.text = str(waterProduction)
	
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



func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.pressed == true:
		print(event.button_index)
		if event.button_index == 1:
			played.emit(self)
		if event.button_index == 2:
			recycled.emit(self)



func getEnergyCost() -> int:
	var cost := green + water + energyProduction
	
	if type == TYPE.ANIMAL:
		cost -= waterProduction
	
	return 5

