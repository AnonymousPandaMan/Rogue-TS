class_name UnitAnimationComponent
extends Node2D

@export var unit_animation_tree : AnimationTree
@export var unit_sprite : Sprite2D

@export var has_animation : bool = true

## ALWAYS USE THESE INSTEAD OF DIRECTLY CHANGING THE PARAMETERS. OTHERWISE WILL SPIT OUT ERRORS.

func set_condition(parameter : String, _bool : bool):
	if has_animation:
		if parameter.length() >= 15:
			unit_animation_tree.set(parameter, _bool)
		else:
			printerr("In trying to set the animation tree parameter " + parameter + " string was shorter than 15 characters and is being auto-corrected. Animations may not function as intended.")
			var corrected_parameter = str("parameters/UnitState/conditions/" + parameter)
			unit_animation_tree.set(corrected_parameter, _bool)

func set_blend_position(parameter : String, location):
	if has_animation:
		if parameter.length() >= 15:
			unit_animation_tree.set(parameter, location)
		else:
			printerr("In trying to set the animation tree parameter " + parameter + " string was shorter than 15 characters and is being auto-corrected. Animations may not function as intended.")
			var corrected_parameter = str("parameters/UnitState/" + parameter + "/blend_position")
			unit_animation_tree.set(corrected_parameter, location)

func set_timescale(timescale):
	if has_animation:
		unit_animation_tree.set("parameters/TimeScale/scale", timescale)
