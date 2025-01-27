class_name ControlGridButton
extends TextureButton

@export var listener_unit_group : String ##Whoever this button affects
var listeners

@export var button_id : String ##Sets conflicting buttons to not display on the UI. If not set, defaults to node name

func ready():
	if not button_id:
		button_id = name
