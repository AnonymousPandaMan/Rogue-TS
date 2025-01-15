extends UnitState

func enter(previous_state_path: String, data := {}) -> void:
	unit.unit_animation.unit_animation_tree.set("parameters/UnitState/conditions/idle", true)
	unit.velocity = Vector2.ZERO
	
func exit():
	unit.unit_animation.unit_animation_tree.set("parameters/UnitState/conditions/idle", false)
