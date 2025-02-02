extends Node3D

#@onready var cam = $XRCamera3D
#var mouseSen: float = 0.01
#var mx: float
#var my: float

var head_bang_speed: float = 2000
var tweener: Tween;
@onready var og: XROrigin3D = $XROrigin3D
var og_tweener: Tween;

@onready var start = $"../Start"
@onready var end = $"../End"
var stPos: Vector3
var enPos: Vector3

var tweenVal: float = 1.
var tweenSpeed: float = 1
var isEndGame: bool = false
var game_start: bool = false

func _ready():
	stPos = start.position
	enPos = end.position
	#enPos = Vector3(randf_range(-1,1), end.position.y, end.position.z)
	#initiate_tween()
	set_process(false)
	EventBus.onImpact.connect(shake_origin)
	EventBus.onEndgame.connect(func(): isEndGame = true)
	EventBus.onRorschach.connect(func(): isEndGame = false)
	EventBus.onGameStop.connect(func(): set_process(false))

func initiate_tween():
	tweener = create_tween()
	#tweener.set_loops()
	activate_tweens()
	tweener.finished.connect(endTween)

func activate_tweens():
	var e = Vector3(randf_range(2.4,1.5), end.position.y, end.position.z)
	stPos = Vector3(randf_range(1.8, 1.6), start.position.y, start.position.z)
	#var e = enPos;
	if(isEndGame):
		tweenVal = randf_range(.3,1.4)
	tweener.set_parallel(true)
	tweener.tween_property(self, "position", e, tweenVal).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tweener.tween_property(self, "rotation_degrees:x", 40, tweenVal).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	tweener.chain().tween_property(self, "position", stPos, tweenVal).set_ease(Tween.EASE_IN)
	tweener.parallel().tween_property(self, "rotation_degrees:x", 0, tweenVal).set_ease(Tween.EASE_IN)
	tweener.tween_interval(tweenVal)


#func _unhandled_input(input_event):
#	if input_event is InputEventMouseMotion:
#		mx = input_event.relative.x;
#		rotate_y(-mx * mouseSen)
#		my = input_event.relative.y;
#		cam.rotate_x(-my * mouseSen)

func randomize_endposition():
	enPos = Vector3(randf_range(-1,1), end.position.y, end.position.z)

func endTween():
	tweener.kill()
	initiate_tween()

func _input(_event):
	if Input.is_action_pressed("LYAxisUP") and game_start == false:
		Engine.time_scale = 1
		game_start = true
		EventBus.onStartGame.emit()
		initiate_tween()
		set_process(true)

func change_speed_var(osc_input: float):
	tweener.set_speed_scale(1000./osc_input)

func _process(_delta):
	head_bang_speed += (Input.get_axis("LYAxisUP", "LYAxisDOWN")) * 8.
	#print(Input.get_axis("LYAxisUP", "LYAxisDOWN"))
	if(head_bang_speed < 70):
			head_bang_speed = 70
	if(head_bang_speed > 2000):
			head_bang_speed = 2000
	change_speed_var(head_bang_speed)

func shake_origin():
	og_tweener = create_tween()
	var og_pos = position
	og_tweener.tween_property(self, "position:x", position.x+0.05, .1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	og_tweener.tween_property(self, "position:x", og_pos.x, .1).set_ease(Tween.EASE_OUT)
