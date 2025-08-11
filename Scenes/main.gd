extends Node

@onready var op_video = $Opening/VideoStreamPlayer
@onready var op_button = $Opening/TextureButton

const START_PAGE = preload("res://Scenes/Start/StartPage.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	op_video.connect("finished", go_to_next)
	op_button.connect("pressed", button_pressed)
	
func go_to_next() -> void :
	var start = START_PAGE.instantiate()
	Transition.change_scene_child(start,self)
	await get_tree().create_timer(1.0).timeout
	remove_child($Opening)

func button_pressed() -> void :
	op_video.disconnect("finished",go_to_next)
	op_video.stop()
	var start = START_PAGE.instantiate()
	Transition.change_scene_child(start,self)
	await get_tree().create_timer(1.0).timeout
	remove_child($Opening)
