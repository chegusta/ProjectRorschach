extends Node

func _ready():
	EventBus.onXRReady.connect(start_game)
	EventBus.onXROff.connect(end_game)


func start_game():
	get_tree().reload_current_scene()

func end_game():
	get_tree().reload_current_scene()
