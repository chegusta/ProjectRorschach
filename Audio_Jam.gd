extends AudioStreamPlayer

@onready var streamo: AudioStreamRandomizer = preload("res://Audio/pentatonic.tres")
var audio_weight: float = 1
var audio_speed: float = 1
@onready var tim: Timer = $Timer

#strings
@onready var stringsAudio: AudioStreamPlayer = $AudioStreamPlayer
@onready var strings: AudioStreamRandomizer = preload("res://Audio/strings.tres")
@onready var strings_timer: Timer = $StringsTimer
var strings_speed: float = 2
@onready var tinitus = $Tinitus
@onready var bang = $Bang

func _ready():
	stream = streamo
	play()
	#tim.timeout.connect(play_audio)
	#finished.connect(play_audio)
	tim.timeout.connect(play_audio)
	strings_timer.timeout.connect(play_strings)
	EventBus.onRorschach.connect(func(): set_process(false))
	EventBus.onRorschach.connect(func(): strings_timer.stop())
	EventBus.onRorschach.connect(func(): tim.stop())
	EventBus.onRorschach.connect(func(): tinitus.play())
	EventBus.onRorschach.connect(func(): bang.play())
	AudioServer.set_bus_volume_db(0, -80)
	EventBus.onStartGame.connect(func(): AudioServer.set_bus_volume_db(0, 0))

func play_audio():
	play()

func play_strings():
	stringsAudio.play()

func _process(delta):
	audio_weight -= (Input.get_axis("RYAxisUP", "RYAxisDOWN"))
	#print(Input.get_axis("LYAxisUP", "LYAxisDOWN"))
	if(audio_weight < 1):
		audio_weight = 1
	if(audio_weight > 100):
		audio_weight = 100
	streamo.set_stream_probability_weight(0, 100-audio_weight)
	streamo.set_stream_probability_weight(1, audio_weight)
	
	_input_pentatonic_playback_speed(delta)
	
	_input_strings(delta)
	
func _input_pentatonic_playback_speed(delta):
	if Input.get_axis("RXAxisRIGHT", "RXAxisLEFT"):
		audio_speed += (Input.get_axis("RXAxisRIGHT", "RXAxisLEFT"))*delta
		if(audio_speed > 1):
			audio_speed = 1
		if(audio_speed < .1):
			audio_speed = .1;
		tim.wait_time = audio_speed

func _input_strings(delta):
	if Input.get_action_strength("RT") or Input.get_action_strength("LT"):
		strings_speed -= Input.get_axis("LT", "RT") * delta
		if(strings_speed > 2):
			strings_speed = 2
		if(strings_speed < .1):
			strings_speed = .1
		strings_timer.wait_time = strings_speed
	
