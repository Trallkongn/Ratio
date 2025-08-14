extends Control

const TITLE_DIALOG = preload("res://Scenes/UserPlayUI/TitleDialog/title_dialog.tscn")

func _on_x_button_pressed() -> void:
	Global.is_ui_hidden = true

func _on_save_button_pressed() -> void:
	var save_table = PreloadSystem.SAVE_TABLE.instantiate()
	get_tree().current_scene.add_child(save_table)

func _on_load_button_pressed() -> void:
	var load_table = PreloadSystem.LOAD_TABLE.instantiate()
	get_tree().current_scene.add_child(load_table)

func _on_title_button_pressed() -> void:
	var title_dialog = TITLE_DIALOG.instantiate()
	add_child(title_dialog)
