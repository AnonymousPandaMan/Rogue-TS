class_name BuildButton
extends ControlGridButton

@export var builds: BuiltUnit

signal build_button_pressed(building : BuiltUnit)


func _on_pressed():
	build_button_pressed.emit(builds)
