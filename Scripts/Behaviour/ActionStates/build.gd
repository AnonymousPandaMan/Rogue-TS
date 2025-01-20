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
		build_target.being_constructed = true
		build_target.state_machine._transition_to_next_state("Constructing")
		unit.requested_navigation_target_position = build_target.global_position
	else:
		printerr("No data for build state for " + unit.name + ". Reverting to IDLE")
		finished.emit(IDLE)
	var facing_direction = unit.velocity.normalized()
	unit.unit_animation.set_blend_position("parameters/UnitState/Build/blend_position",facing_direction.x)
	unit.unit_animation.set_condition("parameters/UnitState/conditions/build", true)

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	unit.unit_animation.set_condition("parameters/UnitState/conditions/build", false)
	if build_target:
		if is_instance_valid(build_target):
			build_target.being_constructed = false
	pass
