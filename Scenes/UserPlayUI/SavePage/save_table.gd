extends Control

const SAVE_SLOT = preload("res://Scenes/UserPlayUI/SavePage/SaveItem.tscn")

@export var slot_count: int = 9   # 9 宫格

func _ready():
	for i in slot_count:
		var slot = SAVE_SLOT.instantiate()
		slot.slot_index = i
		if SaveSystem.has_save(i):
			slot.has_save = true
			slot.save_data = SaveSystem.save_data[i]
		$GridContainer.add_child(slot)		

func refresh():
	print("通过小组调用执行了 refresh 函数")
	
	# 灭
	for slot in $GridContainer.get_children():
		slot.queue_free()
	
	# 创
	for i in slot_count:
		var slot = SAVE_SLOT.instantiate()
		slot.slot_index = i
		if SaveSystem.has_save(i):
			slot.has_save = true
			slot.save_data = SaveSystem.save_data[i]
		$GridContainer.add_child(slot)		

func _on_exit_pressed() -> void:
	Transition.scene_exit(self)
