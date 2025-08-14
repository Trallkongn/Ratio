extends Node

# 用户配置
var config : ConfigFile
var config_data := {}
var is_config_loaded = false

# 场景加载管道
# 预载入数据
var target_json_file : String = ""
var next_scene_current_dialog = 0

# UI隐藏 （调整）
var is_ui_hidden = false


func _ready() -> void:
	# 初始化配置
	config = ConfigFile.new()
	# release 在游戏根目录下创建配置
	#var save_path = OS.get_executable_path().get_base_dir()
	# debug
	var save_path = "user://"
	var err = config.load(save_path.path_join("user.cfg"))
	if err == OK:
		print("用户配置文件载入成功")
		is_config_loaded = true
		load_config()
		
func load_config():
	# 加载用户设置
	print("正在载入用户配置...")
	var ratio_value = config.get_value("Ratio","RatioValue")
	if ratio_value:
		get_window().size = ratio_value
		config_data["ratio_value"] = ratio_value

# 工具函数，用于获取背景图片的路径
func get_background_path(bg_name : String) -> String :
	if bg_name && !bg_name.is_empty():
		var path : String = "res://assets/Pictures/backgrouds/" + bg_name + ".png"
		return path
	else :
		print("没有获取到 background name")
		return ""
		
# 工具函数，根据角色的名称、位置、表情获取图片位置
func get_character_path(ch_name : String, ch_place : String, ch_emotion : String) -> String :
	if ch_name && ch_place && ch_emotion :
		return ("res://assets/Pictures/characters/" + ch_name + "/" + ch_place + "/" + ch_emotion + ".png")
	else :
		print("角色信息不完整")
		return ""

# 工具函数，帮助获取目标场景的剧本位置		
func get_script_path(script_name : String) -> String :
	if script_name && !script_name.is_empty():
		var arr = script_name.split("-")
		var chapter_id = arr[0]
		var path = "res://assets/FilmScripts/"+chapter_id+"/"+script_name+".json"
		print("script path : " + path)
		return path
	else :
		print("无效的剧本名称")
		return ""

# 工具函数，帮助获取目标场景的位置
func get_scene_path(scene_name : String) -> String :
	if scene_name && !scene_name.is_empty() :
		var arr = scene_name.split("-")
		var chapter_id = arr[0]
		var path = "res://Scenes/OrderedScenes/"+chapter_id+"/"+scene_name+".tscn"
		print("scene path : " + path)
		return path
	else :
		print("无效的场景名称")
		return ""
	
	
func _exit_tree() -> void:
	# 在游戏结束之前最后一次保存配置文件
	
	# release 在游戏根目录下创建配置
	#var save_path = OS.get_executable_path().get_base_dir()
	
	# debug
	var save_path = "user://"
	config.save(save_path.path_join("user.cfg"))
