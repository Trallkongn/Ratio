extends Node2D

func _on_back_button_pressed() -> void:
	Transition.scene_exit(self)
