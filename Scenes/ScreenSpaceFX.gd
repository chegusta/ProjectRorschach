extends MeshInstance3D

@onready var timer: Timer = $Timer
var mat: Material
var hits: int = 0
@onready var invert_timer: Timer = $InvertTimer
@export var tex_array: Array[Texture2D] = []

func _ready():
	EventBus.onImpact.connect(apply_effect)
	EventBus.onImpact.connect(func(): hits+=1)
	timer.timeout.connect(reset_shader)
	invert_timer.timeout.connect(func(): mat.set_shader_parameter("invert", randi_range(0,1)))
	invert_timer.timeout.connect(func(): mat.set_shader_parameter("offset", randf()))
	mat = get_active_material(0)
	var currentTexture = tex_array[0]
	mat.set_shader_parameter("displacement_noise", currentTexture)

func apply_effect():
	mat.set_shader_parameter("impactIntensity", 1.0)
	mat.set_shader_parameter("shake_intensity", 1.0)
	mat.set_shader_parameter("blackout", 0.3)
	if hits > 10:
		mat.set_shader_parameter("stretch_multiplier", 2.0);
	if hits > 30:
		mat.set_shader_parameter("abberation_value", 1.0)

func reset_shader():
	mat.set_shader_parameter("impactIntensity", 0.0)
	mat.set_shader_parameter("stretch_multiplier", 0.0);
	mat.set_shader_parameter("blackout", 0.0);
	mat.set_shader_parameter("shake_intensity", 0.0)
	mat.set_shader_parameter("displacement_noise", tex_array.pick_random())
