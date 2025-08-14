extends Node2D
@onready var sprite := $Sprite2D as Sprite2D

# 缓存已加载的纹理，避免重复 load
var cache := {}

# 当前显示的表情名（持久化用）
var current_key : String
var current_character : String
var current_background : String

# 切换表情，duration 控制过渡时间
func change_emotion(new_key: String, duration := 0.4):
	if new_key == current_key: return

	var m := sprite.material as ShaderMaterial
	# 首次调用时初始化
	if not m.get_shader_parameter("tex_from"):
		m.set_shader_parameter("tex_from", load_portrait(new_key))

	# 设置两张图
	m.set_shader_parameter("tex_to",   load_portrait(new_key))
	m.set_shader_parameter("tex_from", load_portrait(new_key))
	m.set_shader_parameter("progress", 0.0)

	current_key = new_key

	# 手动推进 progress（无 Tween，每帧自增）
	var t := 0.0
	while t < duration:
		t += get_process_delta_time() * 0.05
		m.set_shader_parameter("progress", clamp(t / duration, 0.0, 1.0))
		await get_tree().process_frame

	# 结束后把 to 变成新的 from，方便下次
	m.set_shader_parameter("tex_from", load_portrait(current_key))
	m.set_shader_parameter("progress", 0.0)

# 封装加载，带缓存
func load_portrait(new_key : String) -> Texture2D:
	var path = Global.get_character_path(current_character,current_background,new_key)
	var hash_value = path.hash() + new_key.hash()
	if not cache.has(hash_value) :
		cache[hash_value] = load(path)
	return cache[hash_value]
