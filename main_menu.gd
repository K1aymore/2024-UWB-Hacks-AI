extends Control


func _ready() -> void:
	$Credits.hide()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		$Credits.hide()



func _on_play_button_pressed() -> void:
	$ButtonSound.play()
	get_tree().change_scene_to_file("res://super.tscn")



func _on_tutorial_button_pressed() -> void:
	$ButtonSound.play()
	$Tutorial.show()


func _on_credits_button_pressed() -> void:
	$ButtonSound.play()
	$Credits.show()


func _on_quit_button_pressed() -> void:
	$ButtonSound.play()
	get_tree().quit()


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))


func _on_close_credits_button_pressed() -> void:
	$ButtonSound.play()
	$Credits.hide()



func _on_close_tutorial_button_pressed() -> void:
	$Tutorial.hide()
