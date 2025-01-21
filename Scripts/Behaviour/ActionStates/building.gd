extends UnitState

var build_target : Unit

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	if not build_target:
		finished.emit(IDLE)
	#else:
		#if build_target.global_position.distance_to(unit.global_position) >= 500:
			#pass # replace with move to position

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	if data:
		build_target = data.get("BuildTarget")
		build_target.construction_power += unit.unit_stats.build_power
		unit.requested_navigation_target_position = build_target.global_position
		var facing_direction = unit.global_position.direction_to(build_target.global_position)
		unit.unit_animation.set_blend_position("parameters/UnitState/Build/blend_position",facing_direction.x)
		unit.unit_animation.set_condition("parameters/UnitState/conditions/build", true)
	else:
		printerr("No data for build state for " + unit.name + ". Reverting to IDLE")
		finished.emit(IDLE)


## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	unit.unit_animation.set_condition("parameters/UnitState/conditions/build", false)
	if build_target:
		if is_instance_valid(build_target):
			build_target.construction_power -= unit.unit_stats.build_power
	pass
