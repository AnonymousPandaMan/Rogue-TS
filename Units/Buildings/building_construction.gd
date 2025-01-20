extends Unit

var construction_progress := 0.0
var construction_total_time : int = 10

@export_file("*.tscn") var constructed_building : String

@export var progress_bar : ProgressBarComponent

var level_node

func _ready():
	super()
	if owner is Level:
		level_node = owner
	unit_stats.health = 0.1 * unit_stats.max_health
	pass


func _process(delta):
	# Progress construction
	construction_progress += delta
	unit_stats.health += delta * unit_stats.max_health / construction_total_time
	progress_bar.update_progress_bar(construction_progress, construction_total_time)
	if construction_progress >= construction_total_time:
		var new_building = load(constructed_building)
		var completed_building = new_building.instantiate()
		completed_building.global_position = global_position
		level_node.add_child(completed_building)
		queue_free()
