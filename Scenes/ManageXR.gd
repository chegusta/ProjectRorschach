extends Node3D

var interface: XRInterface
var interface2: OpenXRInterface
var xr_active: bool

# Called when the node enters the scene tree for the first time.
func _ready():
#	interface = XRServer.find_interface("OpenXR")
#	if interface and interface.is_initialized():
#		print("VR enabled")
#		get_viewport().use_xr = true
	interface2 = XRServer.find_interface("OpenXR")
	if interface2 and interface2.is_initialized():
		print("OPEN XR enabled")
		get_viewport().use_xr = true
	
	interface2.connect("session_focussed", _xr_focussed)
	interface2.connect("session_visible", _xr_visible)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _xr_focussed():
	print("focussed!")
	#start timer for headbangz
	xr_active = true

func _xr_visible():
	if xr_active:
		xr_active = false
		print("unfocussed")
