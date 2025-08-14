extends Control

# 存档元素的状态调整 有存档时的标签显示 和 无存档时的标签显示

var slot_index : int
var has_save : bool = false
var save_data : Dictionary

@onready var has_save_item = $VBoxContainer
@onready var no_save_item = $NoSave

@onready var snipaste = $Snipaste

@onready var date = $VBoxContainer/date/value
@onready var time = $VBoxContainer/time/value
@onready var character = $VBoxContainer/character/value
@onready var dialog = $VBoxContainer/dialog/value

func _ready() -> void:
	if has_save :
		no_save_item.visible = false
		has_save_item.visible = true
		if save_data:
			print(save_data)
			snipaste.texture = load(Global.get_background_path(save_data["Background"]))
			date.text = save_data["Date"]
			time.text = save_data["Time"]
			character.text = save_data["Character"]
			dialog.text = save_data["DialogText"]
			
# 点击存档
func _on_button_pressed() -> void:
	var save_dialog = SaveSystem.SAVE_DIALOG.instantiate()
	save_dialog.slot_id = slot_index
	get_tree().current_scene.add_child(save_dialog)
