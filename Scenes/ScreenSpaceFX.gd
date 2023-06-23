extends MeshInstance3D

@onready var timer: Timer = $Timer
var mat: Material
var hits: int = 0
@onready var invert_timer: Timer = $InvertTimer
@export var tex_array: Array[Texture2D] = []
@onready var text_timer: Timer = $TextTimer
@onready var vignette_timer: Timer = $VignetteTimer
@onready var env: WorldEnvironment = $"../../../../WorldEnvironment"
var influence_env: bool = false
@onready var glitch_punch = $GlitchPunch
@onready var drone = $Drone
@onready var end_timer = $EndTimer
@onready var first_mat = preload("res://Graphics/FirstGlitchMaterial.tres")
@onready var second_mat = preload("res://Graphics/SecondGlitch.tres")
var vignette: float = 1

var partycles = preload("res://Scenes/partycles.tscn")


var pixel_sizes: Array[int] = [32,64,128]

func _ready():
	var del: Array = get_tree().get_nodes_in_group("Particles")
	for p in del:
		p.queue_free()
		reset_mat()
	EventBus.onImpact.connect(apply_effect)
	EventBus.onImpact.connect(func(): hits+=1)
	timer.timeout.connect(reset_shader)
	mat = get_active_material(0)
	var currentTexture = tex_array[0]
	mat.set_shader_parameter("displacement_noise", currentTexture)
	vignette_timer.timeout.connect(func(): end_timer.start())
	vignette_timer.timeout.connect(func(): EventBus.onEndgame.emit())
	end_timer.timeout.connect(func(): EventBus.onRorschach.emit())
	end_timer.timeout.connect(change_mat)
	hits = 0

func apply_effect():
	mat.set_shader_parameter("impactIntensity", 1.0)
	mat.set_shader_parameter("shake_intensity", 1.0)
	mat.set_shader_parameter("blackout", 0.3)
	if hits > 30:
		mat.set_shader_parameter("stretch_multiplier", 1.0);
	if hits > 50:
		mat.set_shader_parameter("abberation_value", 1.0)
	mat.set_shader_parameter("shader_trans", 1)
	if(randf() > .8):
		mat.set_shader_parameter("pixel_size", pixel_sizes.pick_random())
		mat.set_shader_parameter("pixelation", 1)
	if hits > 100 and randf() > .7:
		Engine.time_scale = randf_range(0.1,2.)
		glitch_punch.play()
		if influence_env:
			env.environment.background_mode = Environment.BG_KEEP
	mat.set_shader_parameter("text_strength", 1)
	timer.start()
	
func reset_shader():
	mat.set_shader_parameter("impactIntensity", 0.0)
	#mat.set_shader_parameter("stretch_multiplier", 0.0);
	mat.set_shader_parameter("blackout", 0.0);
	mat.set_shader_parameter("shake_intensity", 0.0)
	mat.set_shader_parameter("displacement_noise", tex_array.pick_random())
	mat.set_shader_parameter("offset", randf())
	mat.set_shader_parameter("invert", randi_range(0,1))
	mat.set_shader_parameter("pixelation", 0)
	mat.set_shader_parameter("shader_trans", 0)
	mat.set_shader_parameter("text_strength", 0)
	mat.set_shader_parameter("rorScale", randf_range(.2,1))
	mat.set_shader_parameter("rorMove", randf_range(-1,1))
	if influence_env == true:
		env.environment.background_mode = Environment.BG_COLOR
	Engine.time_scale = 1.

func _process(delta):
	if(hits > 10):
		vignette = vignette_timer.time_left / vignette_timer.wait_time
		mat.set_shader_parameter("vignette_value", vignette)
		drone.volume_db += delta*.001
		if drone.volume_db > 1:
			drone.volume_db = 1
	if(hits == 10):
		drone.play()

func change_mat():
	material_override = second_mat
	mat = get_active_material(0)
	influence_env = true
	var p = partycles.instantiate()
	get_tree().root.add_child(p)

func reset_mat():
	material_override = first_mat
	mat = get_active_material(0)
	influence_env = false
	env.environment.background_mode = Environment.BG_SKY
	
	

