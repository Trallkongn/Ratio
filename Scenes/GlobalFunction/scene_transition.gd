extends CanvasLayer

	
func change_scene_packed(node: PackedScene) -> void:
	if node:
		$AnimationPlayer.play("fade_in")
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_packed(node)
		$AnimationPlayer.play("fade_out")
	
func change_scene_node(node: Variant, ref : Variant) -> void:
	if node && ref:
		$AnimationPlayer.play("fade_in")
		await $AnimationPlayer.animation_finished
		get_tree().root.add_child(node)
		ref.queue_free()
		$AnimationPlayer.play("fade_out")
	
func change_scene_path(path: String) -> void:
	if path:
		$AnimationPlayer.play("fade_in")
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_file(path)
		$AnimationPlayer.play("fade_out")

func change_scene_child(node: Variant, ref : Variant) -> void:
	if node && ref:
		$AnimationPlayer.play("fade_in")
		await $AnimationPlayer.animation_finished
		ref.add_child(node)
		$AnimationPlayer.play("fade_out")
		
func scene_exit(ref : Variant) -> void:
	if ref:
		$AnimationPlayer.play("fade_in")
		await $AnimationPlayer.animation_finished
		ref.queue_free()
		$AnimationPlayer.play("fade_out")
	
