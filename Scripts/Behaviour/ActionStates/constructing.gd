extends UnitState

var construction_progress := 0.0
var construction_total_time : int = 30

@export_file("*.tscn") var constructed_building : String

@export var progress_bar : ProgressBarComponent

func enter(previous_state_path: String, data := {}) -> void:
	unit.being_constructed = true
	pass

func update(_delta: float) -> void:
	# Progress construction
	if unit.construction_power > 0:
		var rooted_construction_power = sqrt(unit.construction_power)
		construction_progress += _delta * rooted_construction_power
		unit.unit_stats.health += _delta * 0.9 * unit.unit_stats.max_health / construction_total_time
		progress_bar.update_progress_bar(construction_progress, construction_total_time)
		if construction_progress >= construction_total_time:
			var new_building = load(constructed_building)
			var completed_building = new_building.instantiate()
			completed_building.global_position = unit.global_position
			var level_node = get_tree().get_first_node_in_group("Level")
			level_node.add_child(completed_building)
			unit.queue_free()
	else:
		finished.emit(IDLE)
	
func exit() -> void:
	unit.being_constructed = false
	pass
