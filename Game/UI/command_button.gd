class_name CommandButton
extends ControlGridButton

@export var commanded_state : String ## String of the commanded states name

enum DEMAND_TARGET {TARGET_UNIT, TARGET_LOCATION, SELF, NONE}
@export var demand_target : DEMAND_TARGET
@export var target_group : String ## if demand_target = TARGET_UNIT, the group that is searched from
signal command_button_pressed(commanded_state, target)

func _on_pressed():
	var target
	## currently getting mouse position as the target
	match demand_target:
		DEMAND_TARGET.TARGET_UNIT:
			var mouse_position = get_global_mouse_position()
			target = GlobalFunctions.get_closest_unit_to_location(
				target_group, mouse_position
				)
			if target:
				print(target.name)
			else:
				printerr("no target found")
		DEMAND_TARGET.TARGET_LOCATION:
			target = get_global_mouse_position()
		DEMAND_TARGET.SELF:
			target = owner.owner
		DEMAND_TARGET.NONE:
			target = null
	command_button_pressed.emit(commanded_state, target)
	pass
