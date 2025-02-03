extends Node

func get_closest_unit_to_location(group, location):
	var closest_unit = null
	var all_units = get_tree().get_nodes_in_group(group)
	if (all_units.size() > 0):
		closest_unit = all_units[0]
		for unit in all_units:
			var distance_to_this_unit = location.distance_squared_to(unit.global_position)
			var distance_to_closest_unit = location.distance_squared_to(closest_unit.global_position)
			if (distance_to_this_unit < distance_to_closest_unit):
				closest_unit = unit
	return closest_unit

func format_string(_string):
	pass
