extends CanvasLayer

const START_PAGE = preload("res://Scenes/Start/StartPage.tscn")

func _on_confirm_pressed() -> void:
	var start_page = START_PAGE.instantiate()
	Transition.change_scene_node(start_page)
	queue_free()


func _on_cancel_pressed() -> void:
	queue_free()
