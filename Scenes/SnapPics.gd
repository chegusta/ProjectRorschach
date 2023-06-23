extends SubViewportContainer

@onready var vp: SubViewport = $SubViewport

func _input(event):
#	if event.is_action_released("ui_accept") and xr_active == false:
#		_xr_focussed()
#	if event.is_action_released("ui_cancel") and xr_active == true:
#		_xr_off()
	if event.is_action_released("ui_accept"):
		snap_pic()

func snap_pic():
	#var pic = get_viewport().get_texture().get_image()
	var pic = vp.get_texture().get_image()
	var time: String = Time.get_datetime_string_from_system()
	time = time.replace(":","_")
	var save_path = "user://test" + time + ".png"
	pic.save_png(save_path)
	print(save_path)
