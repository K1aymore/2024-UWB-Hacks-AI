extends Control


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://super.tscn")



func _on_tutorial_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
