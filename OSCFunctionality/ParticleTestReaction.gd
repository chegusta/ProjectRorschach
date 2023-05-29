extends SubViewportContainer

@onready var osc = $".."
@onready var particles = $SubViewport/GPUParticles3D

var offSetCounter: float;
var directionChanger: float;


# Called when the node enters the scene tree for the first time.
func _ready():
	osc.E1_On.connect(Offset)
	osc.E2_On.connect(Detile)
	osc.E2_Off.connect(TileAgain)

#func _process(delta):
#	offSetCounter += delta
#	material.set_shader_parameter("timeMultiplier", offSetCounter)

func Detile() -> void:
	var p = particles.process_material
	p.initial_velocity_max = 5
	material.set_shader_parameter("visMult", 4)
	material.set_shader_parameter("bigScale", .5)

func TileAgain() -> void:
	var p = particles.process_material
	p.initial_velocity_max = 1
	material.set_shader_parameter("visMult", 0.5)
	material.set_shader_parameter("bigScale", 1)

func Offset() -> void:
	directionChanger += .5
	material.set_shader_parameter("dirChange", directionChanger)
	offSetCounter += .5
	material.set_shader_parameter("timeMultiplier", offSetCounter)
