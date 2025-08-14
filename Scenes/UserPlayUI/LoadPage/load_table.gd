extends Control

const LOAD_SLOT = preload("res://Scenes/UserPlayUI/LoadPage/LoadItem.tscn")

@export var slot_count: int = 9   # 9 宫格

func _ready():
	for i in slot_count:
		var slot = LOAD_SLOT.instantiate()
		slot.slot_index = i
		if SaveSystem.has_save(i):
			slot.has_save = true
			slot.save_data = SaveSystem.save_data[i]
		$GridContainer.add_child(slot)	
		
# 退出按钮
func _on_exit_pressed() -> void:
	Transition.scene_exit(self)
