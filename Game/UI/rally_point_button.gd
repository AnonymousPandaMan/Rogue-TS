class_name RallyPointButton
extends ControlGridButton

@export var rally_point_controlled : RallyPoint

signal rally_button_pressed(rally_point)

func _pressed():
	rally_button_pressed.emit(rally_point_controlled)
