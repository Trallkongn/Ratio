extends CanvasLayer

func _on_cancel_pressed() -> void:
	queue_free()


# 对于快速存档，永远只在 0 插槽存放存档数据
func _on_confirm_pressed() -> void:
	get_tree().call_group("Persist","game_save",0)
	print("存档成功存入缓存，已序列化，你可以添加一些反馈")
	queue_free()
