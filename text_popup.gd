extends Node2D
class_name TextPopup


var fade := 2.0
var text : String


func _ready() -> void:
	$Label.text = text


func _process(delta: float) -> void:
	position.y -= delta * 50
	modulate.a = fade
	fade -= delta
	if fade <= 0:
		queue_free()
