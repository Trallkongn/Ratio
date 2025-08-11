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
@onready var m_Character = $Character					# 获取 Character Sprite2D

# 获取底部一排按钮的节点
@onready var option_button = $BottomMenu/buttons/set_button # 设置
@onready var load_button = $BottomMenu/buttons/load_button  # 加载
@onready var save_button = $BottomMenu/buttons/save_button  # 保存

# 预加载底部按钮对应的场景
const OPTION_PAGE = preload("res://Scenes/UserPlayUI/SettingPage.tscn")
const LOAD_TABLE = preload("res://Scenes/UserPlayUI/load_table.tscn")
const SAVE_TABLE = preload("res://Scenes/UserPlayUI/save_table.tscn")

# 全局变量
var json_data : Array			# 用于保存获取到的 JSON 数据
var scene_sequence : String		# 用于保存获取到的 序列数据
var next_scene : String			# 用于保存下一个场景的名称
var scene_info : Array			# 用于获取对话信息
var character_name : String		# 用于获取角色名称
var character_emotion : String  # 用于获取角色表情
var place : String				# 用于获取角色位置
var current_dialog = 0			# 用于表示当前对话的索引，与JSON里的 id 不同

func _ready() -> void:
	# 设置当前场景要使用的JSON文件
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
				background.texture = load(get_background_path(place))
				character_name = scene_info[current_dialog]["character"]
				c_name.text = character_name
				c_dialog.text = scene_info[current_dialog]["text"]
				c_label.text = scene_sequence
				m_Character.texture = load(get_character_path(character_name,place,character_emotion))
			else :
				print("未能成功加载数据 ")
	else :
		print("未得到用于加载游戏的JSON文件")
		
	# 连接按钮点击信号
	action.connect("pressed", action_pressed)
	option_button.connect("pressed",option_button_pressed)
	load_button.connect("pressed", load_button_pressed)
	save_button.connect("pressed", save_button_pressed)
	

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

# 工具函数，用于获取背景图片的路径
func get_background_path(bg_name : String) -> String :
	if bg_name:
		var path : String = "res://assets/Pictures/backgrouds/" + bg_name + ".png"
		return path
	else :
		print("没有获取到 background name")
		return ""
		
# 工具函数，根据角色的名称、位置、表情获取图片位置
func get_character_path(ch_name : String, ch_place : String, ch_emotion : String) -> String :
	if ch_name && ch_place && ch_emotion :
		return ("res://assets/Pictures/characters/" + ch_name + "/" + ch_place + "/" + ch_emotion + "/" + ch_name + ".png")
	else :
		print("character信息不完整")
		return ""

# 点击屏幕的响应，更新UI
func action_pressed() -> void :
	if current_dialog < scene_info.size()-1:
		current_dialog += 1
		character_emotion = scene_info[current_dialog]["emotion"]
		background.texture = load(get_background_path(scene_info[current_dialog]["bg"]))
		character_name = scene_info[current_dialog]["character"]
		c_name.text = character_name
		c_dialog.text = scene_info[current_dialog]["text"]
		m_Character.texture = load(get_character_path(character_name,place,character_emotion))
		
		# debug
		print(current_dialog)
		print(character_name)
		print(character_emotion)
		print(next_scene)
	else :
		turn_to_next_scene()
	
	if Global.is_ui_hidden :
		Global.is_ui_hidden = false

#########################################################	
func option_button_pressed() -> void:
	var option_page = OPTION_PAGE.instantiate()
	Transition.change_scene_child(option_page,self)
	
func load_button_pressed() -> void:
	var load_table = LOAD_TABLE.instantiate()
	Transition.change_scene_child(load_table,self)
	
func save_button_pressed() -> void:
	var save_table = SAVE_TABLE.instantiate()
	Transition.change_scene_child(save_table,self)
#########################################################	

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
		var next_scnen_path : String = "res://Scenes/OrderedScenes/" + next_scene + ".tscn"
		Global.target_json_file = "res://assets/FilmScripts/" + next_scene.split("s")[0] + "/" + next_scene + ".json"
		Transition.change_scene_path(next_scnen_path)
	else :
		print("未能获取下一个场景的名称")
		return
