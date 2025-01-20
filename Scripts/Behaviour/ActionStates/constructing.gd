extends UnitState

var construction_progress := 0.0
var construction_total_time : int = 10

@export_file("*.tscn") var constructed_building : String

@export var progress_bar : ProgressBarComponent

func enter(previous_state_path: String, data := {}) -> void:
	unit.unit_stats.health = 0.1 * unit.unit_stats.max_health
	pass

func update(_delta: float) -> void:
	# Progress construction
	construction_progress += _delta
	unit.unit_stats.health += _delta * unit.unit_stats.max_health / construction_total_time
	progress_bar.update_progress_bar(construction_progress, construction_total_time)
	if construction_progress >= construction_total_time:
		var new_building = load(constructed_building)
		var completed_building = new_building.instantiate()
		completed_building.global_position = unit.global_position
		var level_node = get_tree().get_first_node_in_group("Level")
		level_node.add_child(completed_building)
		queue_free()
	
func exit() -> void:
	pass
