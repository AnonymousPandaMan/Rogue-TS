class_name ControlGridComponent
extends Control

var buttons : Array

func _ready():
	for child in get_children():
		if child is ControlGridButton:
			buttons.append(child) 

func enabled(true_or_false:bool):
	if true_or_false:
		pass
	if not true_or_false:
		pass
