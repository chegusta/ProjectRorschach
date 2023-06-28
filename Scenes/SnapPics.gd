extends SubViewportContainer

@onready var vp: SubViewport = $SubViewport
@onready var audio: AudioStreamPlayer = $SubViewport/AudioStreamPlayer


var is_end_game: bool = false

func _ready():
	is_end_game = false
	EventBus.onRorschach.connect(func(): is_end_game = true)
	EventBus.onGameStop.connect(func(): is_end_game = false)

func _input(event):
	if event.is_action_released("Snap") and is_end_game:
		snap_pic()

func snap_pic():
	#var pic = get_viewport().get_texture().get_image()
	var pic = vp.get_texture().get_image()
	var time: String = Time.get_datetime_string_from_system()
	time = time.replace(":","_")
	var save_path = "user://test" + time + ".png"
	pic.save_png(save_path)
	audio.play()

