extends Node3D

func _ready():
	EventBus.onRorschach.connect(func(): visible = false)
