extends CanvasLayer

# 对于快速加载，永远加载 0 插槽
func _on_confirm_pressed() -> void:
	SaveSystem.change_scenen(SaveSystem.save_data[0]["SaveId"])
	print(SaveSystem.save_data[0]["SaveId"])
	queue_free()

func _on_cancel_pressed() -> void:
	queue_free()
