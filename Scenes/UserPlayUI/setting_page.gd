extends Node2D

@onready var ratio_set = $Items/RatioItem/ratio

func _ready() -> void:
	var size : Vector2i = get_window().size
	if size[0] == 1920 && size[1]== 1080:
		ratio_set.select(0)
	elif size[0] == 1280 && size[1]== 720:
		ratio_set.select(1)
		

func _on_back_pressed() -> void:
	Transition.scene_exit(self)

func _on_ratio_item_selected(index: int) -> void:
	if index == 0 :
		get_window().size = Vector2i(1920, 1080)
	elif index == 1:
		get_window().size = Vector2i(1280,720)
