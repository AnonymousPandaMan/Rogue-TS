extends UnitState

var build_target

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	if is_instance_valid(build_target):
		unit.move_and_slide()
		if unit.global_position.distance_to(build_target.global_position) <= unit.unit_stats.build_range:
			finished.emit(BUILDING, {"BuildTarget" : build_target})
		if unit.global_position.distance_to(build_target.global_position) > unit.unit_stats.build_range - 20:
			unit.requested_navigation_target_position = build_target.global_position
			var move_direction = (
				unit.navigation_component.nav.get_next_path_position() - unit.global_position).normalized()
			unit.velocity = move_direction * unit.unit_stats.move_speed
			var facing_direction = unit.velocity.normalized()
			unit.unit_animation.set_blend_position("parameters/UnitState/Move/blend_position",facing_direction.x)
	else:
		finished.emit(IDLE)
## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	if data:
		build_target = data.get("BuildTarget")
	unit.unit_animation.set_condition("parameters/UnitState/conditions/move", true)
## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	unit.unit_animation.set_condition("parameters/UnitState/conditions/move", false)
