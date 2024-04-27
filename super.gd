extends Control


var inStore := true


func _ready() -> void:
	store()


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
	$Menu.show()
	$Store.hide()
	$Game.hide()

func unpause():
	get_tree().paused = false
	$Menu.hide()
	if inStore:
		store()


func store():
	inStore = true
	$Store.show()
	$Game.hide()
	get_tree().paused = true

func game():
	inStore = false
	$Menu.hide()
	$Store.hide()
	$Game.show()
	get_tree().paused = false


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_store_card_added(card: Card) -> void:
	game()


func _on_game_won_level() -> void:
	store()
