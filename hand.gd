extends Node2D

const STARTINGCARDPOS := Vector2(1000, 0)

func _process(delta: float) -> void:
	for i in range(get_child_count()):
		var card = get_child(i)
		card.position = lerp(card.position, calculatePosition(i), delta * 10)
	


func calculatePosition(i: int) -> Vector2:
	var newPos = Vector2.ZERO
	
	var cardWithMargin = Card.WIDTH + 10
	
	newPos.x = (cardWithMargin * i) - (cardWithMargin * ((get_child_count()-1) / 2.0))
	
	return newPos
