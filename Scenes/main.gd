extends Node

#################################################
# 该node作为游戏的总逻辑层
# 你可以在这里更换你的开场动画
# 或者调整整个游戏的执行顺序
#################################################

# 获取开场动画场景的两个组件
@onready var op_video = $Opening/VideoStreamPlayer
@onready var op_button = $Opening/TextureButton

# 预加载开场动画场景
const START_PAGE = preload("res://Scenes/Start/StartPage.tscn")

# 连接 视频播放结束信号 和 视频点击信号
func _ready() -> void:
	op_video.connect("finished", go_to_next)
	op_button.connect("pressed", button_pressed)

# 默认情况下，当开场动画播放完后进入 开始界面
func go_to_next() -> void :
	var start = START_PAGE.instantiate()
	Transition.change_scene_child(start,self)
	await get_tree().create_timer(1.0).timeout
	remove_child($Opening)

# 提前结束开场动画，进入 开始界面
func button_pressed() -> void :
	# 首先断掉视频结束信号
	op_video.disconnect("finished",go_to_next)
	op_video.stop() # 停止视频播放
	
	# 和 go_to_next 一样
	var start = START_PAGE.instantiate()
	Transition.change_scene_child(start,self)
	await get_tree().create_timer(1.0).timeout
	remove_child($Opening)
