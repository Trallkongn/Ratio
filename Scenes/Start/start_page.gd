extends Node2D

const OPTION_PAGE = preload("res://Scenes/UserPlayUI/SettingPage.tscn")
const LOAD_SCREEN = preload("res://Scenes/GlobalFunction/LoadScreen.tscn")
const LOAD_TABLE = preload("res://Scenes/UserPlayUI/load_table.tscn")
const STAFF_SHOW = preload("res://Scenes/Start/StaffShow.tscn")

func _on_option_button_pressed() -> void:
	var option_page = OPTION_PAGE.instantiate()
	Transition.change_scene_child(option_page,self)

func _on_start_game_button_pressed() -> void:
	var load_screen = LOAD_SCREEN.instantiate()
	load_screen.next_scene = "res://Scenes/OrderedScenes/c1s1.tscn"
	Transition.change_scene_node(load_screen,self)

func _on_load_button_pressed() -> void:
	var load_table = LOAD_TABLE.instantiate()
	Transition.change_scene_child(load_table,self)
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_maker_button_pressed() -> void:
	var staff_show = STAFF_SHOW.instantiate()
	Transition.change_scene_child(staff_show,self)
