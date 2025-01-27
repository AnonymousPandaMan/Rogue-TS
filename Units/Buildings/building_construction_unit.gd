extends Unit

var construction_power := 0.0:
	set(value):
		construction_power = clamp(value, 0, 100)

var being_constructed = false

func _ready():
	super()
	add_to_group("Construction")
	unit_stats.health = 0.1 * unit_stats.max_health
	
func _process(delta):
	if construction_power > 0:
		state_machine._transition_to_next_state("Constructing")
