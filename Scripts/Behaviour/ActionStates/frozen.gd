extends UnitState

func enter(previous_state_path: String, data := {}) -> void:
	unit.unit_animation.set_condition("parameters/UnitState/conditions/idle", true)
	unit.velocity = Vector2.ZERO
	
func exit():
	unit.unit_animation.set_condition("parameters/UnitState/conditions/idle", false)
