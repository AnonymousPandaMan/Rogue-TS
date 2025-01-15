class_name UnitFinderComponent
extends Node2D

func get_closest_unit(allegiance):
	var bodies = get_tree().get_nodes_in_group("Unit")
	var closest_unit = bodies.front()
	for unit in bodies:
		if is_instance_valid(unit):
			var distance_to_this_unit = global_position.distance_squared_to(unit.global_position)
			var distance_to_closest_unit = global_position.distance_squared_to(closest_unit.global_position)
			if (distance_to_this_unit < distance_to_closest_unit) and unit.unit_stats.allegiance == allegiance and unit != owner: # adds to closest unit if an allegiance is declared in the function parameters
				closest_unit = unit
			elif (distance_to_this_unit < distance_to_closest_unit) and not allegiance and unit != owner: # adds to closest unit if NO allegiance is declared in the function parameters
				closest_unit = unit
	if allegiance:
		if closest_unit.unit_stats.allegiance == allegiance:
			return closest_unit
	elif not allegiance:
		return closest_unit
