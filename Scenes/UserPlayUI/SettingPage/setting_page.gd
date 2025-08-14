extends Node2D

@onready var ratio_set = $Items/RatioItem/ratio

func _ready() -> void:
	# 如果文件没有加载，忽略它。
	if Global.is_config_loaded:
		# 配置文件已存在，进行读取操作
		config_init()

func config_init() :
	# 迭代所有小节 获取数据 并 还原设置和UI
	
	# 还原分辨率,并更新UI
	var ratio_value = Global.config.get_value("Ratio","RatioValue")
	if ratio_value == Vector2i(1920,1080):
		ratio_set.select(0)
	elif ratio_value == Vector2i(1280,720):
		ratio_set.select(1)

func _on_back_pressed() -> void:
	Transition.scene_exit(self)

# 分辨率选择 并写入配置文件
func _on_ratio_item_selected(index: int) -> void:
	if index == 0 :
		get_window().size = Vector2i(1920, 1080)
		Global.config.set_value("Ratio","RatioValue",Vector2i(1920,1080))
	elif index == 1:
		get_window().size = Vector2i(1280,720)
		Global.config.set_value("Ratio","RatioValue",Vector2i(1280,720))
		
	# release 在游戏根目录下保存配置文件
	#var save_path = OS.get_executable_path().get_base_dir()
	
	# debug
	var save_path = "user://"
	Global.config.save(save_path.path_join("user.cfg"))
		
func _exit_tree() -> void:
	# 将其保存到文件中（如果已存在则覆盖）。
	
	# release 在游戏根目录下保存配置文件
	#var save_path = OS.get_executable_path().get_base_dir()
	
	# debug
	var save_path = "user://"
	Global.config.save(save_path.path_join("user.cfg"))
