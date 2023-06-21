extends Node

var interface: XRInterface
var interface2: OpenXRInterface
var xr_active: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	interface2 = XRServer.find_interface("OpenXR")
	if interface2 and interface2.is_initialized():
		print("OPEN XR enabled")
		get_viewport().use_xr = true
		print(interface2.get_capabilities())
	
	interface2.connect("session_focussed", _xr_focussed)
	interface2.connect("session_visible", _xr_off)


func _xr_focussed():
	print("focussed!")
	#start timer for headbangz
	xr_active = true
	EventBus.onXRReady.emit()

func _xr_off():
	if xr_active:
		xr_active = false
		print("unfocussed")
		EventBus.onXROff.emit()

####Debuggin without gogglez!
func _input(event):
	if event.is_action_released("ui_accept") and xr_active == false:
		_xr_focussed()
	if event.is_action_released("ui_accept") and xr_active == true:
		_xr_off()
