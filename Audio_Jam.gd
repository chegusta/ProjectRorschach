extends AudioStreamPlayer

@onready var streamo: AudioStreamRandomizer = preload("res://Audio/pentatonic.tres")
var audio_weight: float = 1
var audio_speed: float = 1
@onready var tim: Timer = $Timer


func _ready():
	stream = streamo
	play()
	print("audio Ready")
	#tim.timeout.connect(play_audio)
	#finished.connect(play_audio)
	tim.timeout.connect(play_audio)

func play_audio():
	play()
	

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

func _input_pentatonic_playback_speed(delta):
	if Input.get_axis("RXAxisRIGHT", "RXAxisLEFT"):
		audio_speed += (Input.get_axis("RXAxisRIGHT", "RXAxisLEFT"))*delta*.5
		if(audio_speed > 1):
			audio_speed = 1
		if(audio_speed < .1):
			audio_speed = .1;
		tim.wait_time = audio_speed
		
