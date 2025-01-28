class_name BuildButton
extends ControlGridButton

@export var builds: BuiltUnit

var build_overlay_scene : PackedScene = preload("res://Game/UI/build_overlay.tscn")

signal build_button_pressed(building : BuiltUnit, build_location)


func _on_pressed():
	if GameInventory.has_enough_resources(
		"Wood", builds.unit_costs.wood_cost) and GameInventory.has_enough_resources(
			"Meat", builds.unit_costs.meat_cost) and GameInventory.has_enough_resources(
				"Gold", builds.unit_costs.gold_cost): 
		var build_overlay = build_overlay_scene.instantiate()
		build_overlay.start_selection(builds)
		build_overlay.confirmed_placement_location.connect(_on_confirmed_placement_location)
		get_tree().get_first_node_in_group("Level").add_child(build_overlay)
		
	else:
		print("Not enough resources")
		return null

func _on_confirmed_placement_location(placement_location):
	build_button_pressed.emit(builds, placement_location)
	print("Building " + builds.unit_stats.unit_name + " at " + str(placement_location))
