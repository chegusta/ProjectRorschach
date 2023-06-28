extends Label3D

@onready var timer: Timer = $Timer
@onready var audio_timer: Timer = $AudioTimer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var end_timer: Timer = $EndingTimer
@onready var remaining_time: Label3D = $RemainingTime

func _ready():
	set_process(false)
	EventBus.onRorschach.connect(func(): timer.start())
	EventBus.onRorschach.connect(func(): set_process(true))
	EventBus.onRorschach.connect(func(): audio_timer.start())
	EventBus.onRorschach.connect(func(): audio.play())
	audio_timer.timeout.connect(func(): audio.play())
	EventBus.onRorschach.connect(func(): end_timer.start())
	end_timer.timeout.connect(func(): EventBus.onGameStop.emit())
	EventBus.onGameStop.connect(show_end_game)

func _process(_delta):
	modulate.a = timer.time_left / timer.wait_time
	remaining_time.text = str(round(end_timer.time_left))

func show_end_game():
	set_process(false)
	audio_timer.stop()
	modulate.a = 1;
	var count: int = get_directory_count()
	var formated: String = "{int} images classified collectively."
	var stringo: String = formated.format({"int": count})
	text = stringo
	
func get_directory_count() -> int:
	var path = "user://"
	var dir = DirAccess.open(path)
	return dir.get_files().size()
