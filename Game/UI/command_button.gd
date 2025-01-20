class_name CommandButton
extends ControlGridButton

@export var commanded_state : String ## String of the commanded states name
@export var commanded_unit : Unit

enum DEMAND_TARGET {TARGET_UNIT, TARGET_LOCATION, SELF, NONE}
@export var demand_target : DEMAND_TARGET
@export var target_group : String ## if demand_target = TARGET_UNIT, the group that is searched from
signal command_button_pressed(commanded_state, target)




func _on_pressed():
	var target
	## currently getting mouse position as the target
	match demand_target:
		DEMAND_TARGET.TARGET_UNIT:
			var mouse_position = get_node("/root/Level").get_global_mouse_position()
			var closest_target = GlobalFunctions.get_closest_unit_to_location(
				target_group, mouse_position
				)
			if closest_target:
				print(closest_target.name + str(closest_target.global_position.distance_to(mouse_position)))
				if closest_target.global_position.distance_to(mouse_position) <= 300:
					target = closest_target
					print(target.name)
				else:
					return
			else:
				printerr("no target found")
				return
		DEMAND_TARGET.TARGET_LOCATION:
			target = get_global_mouse_position()
		DEMAND_TARGET.SELF:
			target = commanded_unit # probably doesnt work
		DEMAND_TARGET.NONE:
			target = null
	command_button_pressed.emit(commanded_state, target)
	pass
