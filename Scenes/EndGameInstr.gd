extends Label3D

@onready var timer: Timer = $Timer

func _ready():
	set_process(false)
	EventBus.onEndgame.connect(func(): timer.start())
	EventBus.onEndgame.connect(func(): set_process(true))

func _process(delta):
	modulate.a = timer.time_left / timer.wait_time
