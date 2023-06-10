extends Area3D

@onready var impact_audio: AudioStreamPlayer = $AudioStreamPlayer

func _on_area_entered(area):
	EventBus.onImpact.emit()
	impact_audio.play()
