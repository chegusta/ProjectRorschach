extends Area3D

func _on_area_entered(area):
	EventBus.onImpact.emit()
	print("hit")
