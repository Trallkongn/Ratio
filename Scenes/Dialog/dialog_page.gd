extends Node2D

##############################################################################
# Read Me
# 2025-8-10
# 该文件为对话场景的核心脚本文件，已将其和 DialogPage 进行绑定
# 使用时请新建 空白Node，然后实例化 DialogPage 即可
# 目前处于开发阶段，使用JSON作为剧本格式化文本格式，详见 res://assets/FilmScripts/
##############################################################################


# 从 Global.target_json_file 设置当前场景要使用的JSON文件
@export var target_json_file : String

# 获取 DialogPage 下的节点
@onready var action = $Dialog/TextureButton				# 一个几乎占据全屏的按钮，用于跳到下一句对话
@onready var background = $Background					# 背景
@onready var c_name = $Dialog/Control/CharacterName		# 角色名称标签
@onready var c_dialog = $Dialog/Control/Dialog			# 对话文本节点
@onready var c_label = $Dialog/Control/Label			# 用于显示当前序列的标签
@onready var m_Control = $Dialog/Control				# 获取 Control 父级节点，用于UI的隐藏
@onready var m_Character = $Character2D

# 获取底部一排按钮的节点
@onready var option_button = $BottomMenu/buttons/set_button # 设置
@onready var save_button = $BottomMenu/buttons/save_button  # 保存

# 全局变量
var json_data : Array			# 用于保存获取到的 JSON 数据
var scene_sequence : String		# 用于保存获取到的 序列数据
var next_scene : String			# 用于保存下一个场景的名称
var scene_info : Array			# 用于获取对话信息
var character_name : String		# 用于获取角色名称
var character_emotion : String  # 用于获取角色表情
var place : String				# 用于获取角色位置
var dialog_text : String		# 用于获取角色对话
var current_dialog = 0			# 用于表示当前对话的索引，与JSON里的 id 不同

# 缓存
var cache := {}

func _ready() -> void:
	# 设置当前场景要使用的JSON文件
	current_dialog = Global.next_scene_current_dialog
	target_json_file = Global.target_json_file
	
	# 读取JSON和获取数据，并初始化UI
	if target_json_file:
		var id1 = read_json()
		if id1:
			# JSON文件读取成功，获取数据
			var id2 = load_data()
			if id2 : 
				# 读取数据成功，初始化UI
				character_emotion = scene_info[current_dialog]["emotion"]
				place = scene_info[current_dialog]["bg"]
				background.texture = get_background(Global.get_background_path(place))
				character_name = scene_info[current_dialog]["character"]
				c_name.text = character_name
				dialog_text = scene_info[current_dialog]["text"]
				c_dialog.text = dialog_text
				c_label.text = scene_sequence
				
				m_Character.current_background = place
				m_Character.current_character = character_name
				m_Character.change_emotion(character_emotion)
			else :
				print("未能成功加载数据 ")
	else :
		print("未得到用于加载游戏的JSON文件")
		
	# 连接按钮点击信号
	action.connect("pressed", action_pressed)
	
func _process(_delta: float) -> void:
	# UI 隐藏按钮检测
	if Global.is_ui_hidden :
		m_Control.visible = false
		$BottomMenu.visible = false
	if !Global.is_ui_hidden :
		m_Control.visible = true
		$BottomMenu.visible = true
	
# 读取JSON文件
func read_json() -> bool :
	var file = FileAccess.open(target_json_file,FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(json_text)
		if error==OK:
			json_data = json.data
			print(json_data)
			return true
		else :
			print("JSON 解析失败：", json.get_error_message())
			return false
	else :
		print("无法打开JSON文件：", FileAccess.get_open_error())
		return false
		
# 加载数据
func load_data() -> bool :
	if json_data.size() == 2:
		scene_sequence = json_data[0]["sequence"]
		next_scene = json_data[0]["next_scene"]
		scene_info = json_data[1]
		return true
	else :
		print("数据错误")
		return false

# 点击屏幕的响应，更新UI
func action_pressed() -> void :
	if current_dialog < scene_info.size()-1:
		current_dialog += 1
		character_emotion = scene_info[current_dialog]["emotion"]
		background.texture = get_background(Global.get_background_path(place))
		character_name = scene_info[current_dialog]["character"]
		c_name.text = character_name
		dialog_text = scene_info[current_dialog]["text"]
		c_dialog.text = dialog_text
		
		m_Character.current_background = place
		m_Character.current_character = character_name
		m_Character.change_emotion(character_emotion)
				
		# debug
		print(current_dialog)
		print(character_name)
		print(character_emotion)
		print(next_scene)
	else :
		turn_to_next_scene()
	
	if Global.is_ui_hidden :
		Global.is_ui_hidden = false

# 如果接下来没有对话，就跳转到下一个场景
# debug
#func turn_to_next_scene() -> void:
	#if next_scene :
		#var next_scnen_path : String = "res://Scenes/OrderedScenes/" + next_scene + ".tscn"
		#if FileAccess.file_exists(next_scnen_path) : 
			#Global.target_json_file = "res://assets/FilmScripts/" + next_scene.split("s")[0] + "/" + next_scene + ".json"
			#Transition.change_scene_path(next_scnen_path)
		#else :
			#print("未能找到目标场景")
			#return
	#else :
		#print("未能获取下一个场景的名称")
		#return

# release
func turn_to_next_scene() -> void:
	if next_scene :
		var next_scnen_path : String = Global.get_scene_path(next_scene)
		Global.target_json_file = Global.get_script_path(next_scene)
		Transition.change_scene_path(next_scnen_path)
		Global.next_scene_current_dialog = 0
	else :
		print("未能获取下一个场景的名称")
		return

# 从缓存中获取背景资源
func get_background(background_path : String) :
	var hash_value = background_path.hash()
	if not cache.has(hash_value):
		cache[hash_value] = load(background_path)
	return cache[hash_value]
	
# 通过全局分组调用的游戏保存函数
func game_save(slot_id : int) :
	print("通过小组调用执行了 game_save 函数")
	
	var t := Time.get_datetime_dict_from_system()
	var year  = 	str(t.year)          # 2025
	var month = 	str(t.month)         # 8
	var day   = 	str(t.day)           # 14
	var hour  = 	str(t.hour)          # 15
	var minute= 	str(t.minute)        # 42
	var second= 	str(t.second)        # 7
	var weekday= 	str(t.weekday)       # 4（Thursday）
	
	var Save = {}
	
	var save_id = Global.target_json_file.get_file().get_basename() + "-" + str(scene_info[current_dialog]["id"])
	
	Save["SaveId"] = save_id
	Save["Slot"] = slot_id
	Save["Date"] = year+"-"+month+"-"+day
	Save["Time"] = hour+":"+minute+":"+second+" "+weekday
	Save["Background"] = place
	Save["Character"] = character_name
	Save["DialogId"] = scene_info[current_dialog]["id"]
	Save["DialogText"] = dialog_text
	
	SaveSystem.save_data[slot_id] = Save
