extends UnitState

var producing_unit = preload("res://Units/unit.tscn") # needs to be changed to be able to be used in a dict
@export var production_time := 10


var current_production_progress = 0.0
var produced_unit

## CURRENTLY UNUSED

func enter(previous_state_path: String, data := {}) -> void:
	pass


func update(_delta: float) -> void:
	if current_production_progress >= production_time:
		produced_unit = producing_unit.instantiate()
		produced_unit.position = unit.position
		add_child(produced_unit)
		print(unit.name + " produced a unit")
		current_production_progress = 0.0
		finished.emit("Idle")
	else:
		current_production_progress += _delta
		print(current_production_progress)

	pass
