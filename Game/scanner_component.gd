class_name ScannerComponent
extends Area2D

var units_in_scan_range : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	## Pretty scuffed way of avoiding area 2D not seeing body enters on initial instance
	var init_overlap = get_tree().get_nodes_in_group("Unit")
	await owner.ready
	await get_tree().physics_frame
	#scan_bodies_in_area()
	#for unit in init_overlap:
		#if unit.global_position.distance_to(global_position) <= owner.unit_stats.attack_range*2:
			#units_in_scan_range.append(unit)
	#pass # Replace with function body.
	


func _physics_process(delta):
	#scan_bodies_in_area()
	pass
#
#func scan_bodies_in_area():
	##await get_tree().physics_frame
	#var bodies_in_area = get_overlapping_bodies()
	#for body in bodies_in_area:
		#if body != owner:
			#if not units_in_scan_range.has(body):
				#units_in_scan_range.append(body)
				#print(units_in_scan_range.front().name)

func get_closest_unit_in_range(allegiance):
	var bodies = get_overlapping_bodies()
	if bodies.size() > 0:
		var closest_unit = bodies.front()
		if is_instance_valid(closest_unit):
			for unit in bodies:
				if is_instance_valid(unit):
					var distance_to_this_unit = global_position.distance_squared_to(unit.global_position)
					var distance_to_closest_unit = global_position.distance_squared_to(closest_unit.global_position)
					if (distance_to_this_unit < distance_to_closest_unit) and closest_unit.unit_stats.allegiance == allegiance: # adds to closest unit if an allegiance is declared in the function parameters
						closest_unit = unit
					elif (distance_to_this_unit < distance_to_closest_unit) and not allegiance: # adds to closest unit if NO allegiance is declared in the function parameters
						closest_unit = unit
			if allegiance:
				if closest_unit.unit_stats.allegiance == allegiance:
					return closest_unit
			elif not allegiance:
				return closest_unit


func _on_body_entered(body):
	if units_in_scan_range.has(body) and body != owner:
		units_in_scan_range.append(body)
#
func _on_body_exited(body):
	units_in_scan_range.erase(body)
