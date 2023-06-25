extends Label3D

@onready var timer: Timer = $Timer
@onready var audio_timer: Timer = $AudioTimer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	set_process(false)
	EventBus.onRorschach.connect(func(): timer.start())
	EventBus.onRorschach.connect(func(): set_process(true))
	EventBus.onRorschach.connect(func(): audio_timer.start())
	audio_timer.timeout.connect(func(): audio.play())

func _process(delta):
	modulate.a = timer.time_left / timer.wait_time
