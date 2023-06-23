extends Node

var interface: XRInterface
var interface2: OpenXRInterface
var xr_active: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	interface2 = XRServer.find_interface("OpenXR")
	if interface2 and interface2.is_initialized():
		#print("OPEN XR enabled")
		get_viewport().use_xr = true
		#print(interface2.get_capabilities())
	
	interface2.connect("session_focussed", _xr_focussed)
	interface2.connect("session_visible", _xr_off)


func _xr_focussed():
	#print("focussed!")
	#start timer for headbangz
	xr_active = true
	EventBus.onXRReady.emit()

func _xr_off():
	if xr_active:
		xr_active = false
		#print("unfocussed")
		EventBus.onXROff.emit()

####Debuggin without gogglez!
#func _input(event):
##	if event.is_action_released("ui_accept") and xr_active == false:
##		_xr_focussed()
##	if event.is_action_released("ui_cancel") and xr_active == true:
##		_xr_off()
#	if event.is_action_released("ui_accept"):
#		snap_pic()
#
#func snap_pic():
#	var pic = get_viewport().get_texture().get_image()
#	var time: String = Time.get_datetime_string_from_system()
#	time = time.replace(":","_")
#	var save_path = "user://test" + time + ".png"
#	pic.save_png(save_path)
#	print(save_path)
