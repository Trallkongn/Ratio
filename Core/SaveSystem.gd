extends Node

const SAVE_DIALOG = preload("res://Scenes/UserPlayUI/SavePage/SaveDialog.tscn")
const LOAD_DIALOG = preload("res://Scenes/UserPlayUI/LoadPage/LoadDialog.tscn")

var save_data := {}

# 保存路径
const SAVE_PATH = "user://save.bin"	

func _ready() -> void:
	load_game()

# 单次保存游戏
func save_game() -> void :
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(save_data, true)   # 第2个参数=full_objects
	print("存档成功")
	file.close()

# 游戏启动时从文件中加载存档
func load_game() -> void :
	if not FileAccess.file_exists(SAVE_PATH):
		print("无存档")
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	save_data = file.get_var(true)
	file.close()

# TODO: impl
func has_save(slot_index : int) -> bool :
	if save_data && save_data.has(slot_index):
		return true
	return false
	
# 选择插槽后进入对应的场景
func change_scenen(save_id : String) :
	var arr = save_id.split("-")
	if arr.size() == 3:
		var chapter_id = arr[0]
		var scene_id = arr[1]
		var dialog_id = arr[2]
		# 剧本名称为 chapter_id + "-" + scene_id
		var script_path = Global.get_script_path(chapter_id+"-"+scene_id)
		Global.target_json_file = script_path
		# 场景名称和剧本名称相同
		var scene_path = Global.get_scene_path(chapter_id+"-"+scene_id)
		var load_screen = PreloadSystem.LOAD_SCREEN.instantiate()
		load_screen.next_scene = scene_path
		Global.next_scene_current_dialog = dialog_id.to_int()-1
		Transition.change_scene_node(load_screen)
	else :
		print("存档id格式不正确")
	
