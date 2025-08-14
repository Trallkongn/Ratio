extends Node2D

@export var next_scene : String = ""

@onready var m_StatusLabel = $StatusLabel
@onready var m_ProgressBar = $ProgressBar

var last_progress = 0.0

func _ready() -> void:
	ResourceLoader.load_threaded_request(next_scene)
	pass

func _process(delta: float) -> void:	
	var progress = []
	var load_status = ResourceLoader.load_threaded_get_status(next_scene,progress)
	var new_progress = progress[0] * 100.0
	
	if new_progress > last_progress:
		last_progress = new_progress
	
	m_ProgressBar.value = lerp(m_ProgressBar.value, last_progress, delta*5)
	
	if load_status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		m_ProgressBar.value = 100.0
		await get_tree().create_timer(2.0).timeout
		var packed_next_scene = ResourceLoader.load_threaded_get(next_scene)
		Transition.change_scene_packed(packed_next_scene)
		
		# 等待动画
		await get_tree().create_timer(1.0).timeout
		queue_free()
	
	
