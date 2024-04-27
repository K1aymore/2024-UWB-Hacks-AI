extends Control


func _ready() -> void:
	unpause()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		if get_tree().paused:
			unpause()
		else:
			pause()


func _on_play_button_pressed() -> void:
	unpause()


func pause():
	get_tree().paused = true
	$Menu.visible = true

func unpause():
	get_tree().paused = false
	$Menu.visible = false


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_store_card_added(card: Card) -> void:
	$Store.hide()
	$Game.show()
