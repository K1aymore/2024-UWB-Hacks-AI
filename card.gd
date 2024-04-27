extends Area2D
class_name Card

const WIDTH := 270

@export var title : String
@export_multiline var flavorText : String

@export var green : int
@export var water : int
@export var energy : int

@export var level := 1


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
	%WaterCost.text = str(water)
	%GreenGeneration.text = str(green)
	
	match type:
		TYPE.PLANT:
			$Background.texture = load("res://CardArt/plant_template.png")
			%Generation.text = str(energy)
		TYPE.ANIMAL:
			$Background.texture = load("res://CardArt/animal_template.png")
			%Generation.text = str(energy)
		TYPE.WEATHER:
			$Background.texture = load("res://CardArt/weather_template.png")
			%Generation.text = str(water)
			%WaterCost.text = ""



func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.pressed == true:
		if event.button_index == 1:
			played.emit(self)
		if event.button_index == 2:
			recycled.emit(self)



func getEnergyCost() -> int:
	var cost := green + energy
	
	if type == TYPE.WEATHER:
		cost += water
	else:
		cost -= water
	
	return cost / level
