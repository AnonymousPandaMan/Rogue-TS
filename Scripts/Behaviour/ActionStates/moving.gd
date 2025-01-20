extends UnitState

var target_position = Vector2()

func enter(previous_state_path: String, data := {}) -> void:
	if data:
		target_position = data.get("MoveTarget")
		unit.requested_navigation_target_position = target_position
		unit.unit_animation.set_condition("parameters/UnitState/conditions/move", true)
	else:
		finished.emit(IDLE)


func physics_update(_delta: float) -> void:
	unit.move_and_slide()
	if unit.position.distance_to(target_position) >= 10:
		var target_direction = (
			unit.navigation_component.nav.get_next_path_position() - unit.global_position).normalized()
		unit.velocity = target_direction * unit.unit_stats.move_speed
		var facing_direction = unit.velocity.normalized()
		unit.unit_animation.set_blend_position("parameters/UnitState/Move/blend_position",facing_direction.x)
	else:
		finished.emit(IDLE)

func exit():
	unit.unit_animation.set_condition("parameters/UnitState/conditions/move", false)
	pass
	
