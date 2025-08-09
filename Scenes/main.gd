extends Node

const OPENING_PAGE = preload("res://Scenes/Start/Opening.tscn")
const START_PAGE = preload("res://Scenes/Start/StartPage.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var open = OPENING_PAGE.instantiate()
	var start = START_PAGE.instantiate()
	add_child(open)
	await get_tree().create_timer(8.0).timeout
	Transition.change_scene_child(start,self)
	await get_tree().create_timer(1.0).timeout
	remove_child(open)
