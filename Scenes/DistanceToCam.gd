@tool

extends SpringArm3D

@onready var cam = $"../XROrigin3D"

func _process(delta):
	var distV: Vector3 = cam.position - position;
	var distanceToCam: float = distV.length()
	spring_length = distanceToCam;
