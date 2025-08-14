extends CanvasLayer

var slot_id : int

func _on_cancel_pressed() -> void:
	queue_free()

func _on_confirm_pressed() -> void:
	get_tree().call_group("Persist","game_save",slot_id)
	get_tree().call_group("Persist","refresh")
	SaveSystem.save_game()
	await get_tree().process_frame
	queue_free()
