extends Node3D

#@onready var cam = $XRCamera3D
#var mouseSen: float = 0.01
#var mx: float
#var my: float

var tweener: Tween;

@onready var start = $"../Start"
@onready var end = $"../End"
var stPos: Vector3
var enPos: Vector3

var tweenVal: float = 1.
var tweenSpeed: float = 1
@onready var osc = $"../OSC"

func _ready():
	stPos = start.position
	enPos = end.position
	osc.E1_On.connect(change_speed_var)
	
	#enPos = Vector3(randf_range(-1,1), end.position.y, end.position.z)
	initiate_tween()

func initiate_tween():
	tweener = create_tween()
	tweener.set_loops()
	activate_tweens()
	tweener.finished.connect(endTween)

func activate_tweens():
	#var e = Vector3(randf_range(-1,1), end.position.y, end.position.z)
	var e = enPos;
	tweener.set_parallel(true)
	tweener.tween_property(self, "position", e, tweenVal).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tweener.tween_property(self, "rotation_degrees:x", 40, tweenVal).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tweener.chain().tween_property(self, "position", stPos, tweenVal).set_ease(Tween.EASE_OUT)
	tweener.parallel().tween_property(self, "rotation_degrees:x", 0, tweenVal).set_ease(Tween.EASE_OUT)
	tweener.tween_interval(tweenVal)


#func _unhandled_input(input_event):
#	if input_event is InputEventMouseMotion:
#		mx = input_event.relative.x;
#		rotate_y(-mx * mouseSen)
#		my = input_event.relative.y;
#		cam.rotate_x(-my * mouseSen)

func randomize_endposition():
	enPos = Vector3(randf_range(-1,1), end.position.y, end.position.z)
	print(enPos.x)

func endTween():
	tweener.kill
	initiate_tween()

func change_speed_var(osc_input: float):
	tweener.set_speed_scale(1000./osc_input)
