extends Node2D

# 预加载职员表
const STAFF_SHOW = preload("res://Scenes/Start/StaffShow.tscn")

# 选项设置
func _on_option_button_pressed() -> void:
	var option_page = PreloadSystem.OPTION_PAGE.instantiate()
	Transition.change_scene_child(option_page,self)

# 开始游戏
func _on_start_game_button_pressed() -> void:
	var load_screen = PreloadSystem.LOAD_SCREEN.instantiate()
	Global.target_json_file = "res://assets/FilmScripts/c1/c1-s1.json"
	Global.next_scene_current_dialog = 0
	load_screen.next_scene = "res://Scenes/OrderedScenes/c1/c1-s1.tscn"
	Transition.change_scene_node(load_screen)
	await get_tree().create_timer(1.0).timeout
	queue_free()

# 加载存档
func _on_load_button_pressed() -> void:
	var load_table = PreloadSystem.LOAD_TABLE.instantiate()
	Transition.change_scene_child(load_table,self)

# 退出游戏
func _on_exit_button_pressed() -> void:
	get_tree().quit()

# 制作人员
func _on_maker_button_pressed() -> void:
	var staff_show = STAFF_SHOW.instantiate()
	Transition.change_scene_child(staff_show,self)

# 继续游戏
func _on_continue_button_pressed() -> void:
	SaveSystem.change_scenen(SaveSystem.save_data[0]["SaveId"])
	await get_tree().create_timer(1.0).timeout
	queue_free()
