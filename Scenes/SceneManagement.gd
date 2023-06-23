extends Node

func _ready():
	Engine.time_scale = 0
	EventBus.onXRReady.connect(start_game)
	EventBus.onXROff.connect(end_game)

func start_game():
	get_tree().change_scene_to_file("res://Scenes/MetaVerseRoom.tscn")
	Engine.time_scale = 0

func end_game():
	get_tree().change_scene_to_file("res://Scenes/MetaVerseRoom.tscn")
	Engine.time_scale = 0
