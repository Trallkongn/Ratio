extends Node2D

@export var target_json_file : String

@onready var action = $Dialog/TextureButton
@onready var background = $Background
@onready var c_name = $Dialog/Control/CharacterName
@onready var c_dialog = $Dialog/Control/Dialog
@onready var c_label = $Dialog/Control/Label

@onready var m_Control = $Dialog/Control

@onready var option_button = $BottomMenu/buttons/set_button
@onready var load_button = $BottomMenu/buttons/load_button
@onready var save_button = $BottomMenu/buttons/save_button

const OPTION_PAGE = preload("res://Scenes/UserPlayUI/SettingPage.tscn")
const LOAD_TABLE = preload("res://Scenes/UserPlayUI/load_table.tscn")
const SAVE_TABLE = preload("res://Scenes/UserPlayUI/save_table.tscn")


var next_scene : String
var json_data : Array

var scene_sequence : String
var scene_info : Array

var current_dialog = 0

func _ready() -> void:
	target_json_file = Global.target_json_file
	if target_json_file:
		var id1 = read_json()
		if id1:
			var id2 = load_data()
			if id2 : 
				background.texture = load(get_background_path(scene_info[0]["bg"]))
				c_name.text = scene_info[0]["character"]
				c_dialog.text = scene_info[0]["text"]
				c_label.text = json_data[0]
			else :
				print("未能成功加载数据 ")
	else :
		print("未得到用于加载游戏的JSON文件")
		
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
		
func load_data() -> bool :
	if json_data.size() == 2:
		scene_sequence = json_data[0]
		scene_info = json_data[1]
		return true
	else :
		print("数据错误")
		return false

func get_background_path(bg_name : String) -> String :
	if bg_name:
		var path : String = "res://assets/Pictures/backgrouds/" + bg_name + ".png"
		return path
	else :
		print("没有获取到 name")
		return ""
	
func action_pressed() -> void :
	if current_dialog < scene_info.size()-1:
		current_dialog += 1
		background.texture = load(get_background_path(scene_info[current_dialog]["bg"]))
		c_name.text = scene_info[current_dialog]["character"]
		c_dialog.text = scene_info[current_dialog]["text"]
	else :
		print("接下来已经没有对话了")
	
	if Global.is_ui_hidden :
		Global.is_ui_hidden = false
		
func option_button_pressed() -> void:
	var option_page = OPTION_PAGE.instantiate()
	Transition.change_scene_child(option_page,self)
	
func load_button_pressed() -> void:
	var load_table = LOAD_TABLE.instantiate()
	Transition.change_scene_child(load_table,self)
	
func save_button_pressed() -> void:
	var save_table = SAVE_TABLE.instantiate()
	Transition.change_scene_child(save_table,self)
	
	
	
	
