extends CanvasLayer

var save_id : String

func _on_cancel_pressed() -> void:
	queue_free()


func _on_confirm_pressed() -> void:
	if save_id:
		SaveSystem.change_scenen(save_id)
	else :
		print("未能成功获取 save_id")
	queue_free()
