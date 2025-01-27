extends UnitState
## Move and start construction

var construction_target

signal construction_target_reached(unit)

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	unit.move_and_slide()
	if is_instance_valid(construction_target):
		if unit.global_position.distance_to(construction_target.global_position) >= unit.unit_stats.build_range:
			var target_direction = (
				unit.navigation_component.nav.get_next_path_position() - unit.global_position).normalized()
			unit.velocity = target_direction * unit.unit_stats.move_speed
			var facing_direction = unit.velocity.normalized()
			unit.unit_animation.set_blend_position("parameters/UnitState/Move/blend_position",facing_direction.x)
		else:
			construction_target._on_construction_start()
		pass
		# start construction
		# switch to build state
## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	if data:
		construction_target = data.get("ConstructionTarget")
		construction_target.assigned_units.append(unit)
		unit.requested_navigation_target_position = construction_target.global_position
		unit.unit_animation.set_condition("parameters/UnitState/conditions/move", true)
	else:
		printerr("No data for construction start state for " + unit.name + ". Reverting to IDLE")
		finished.emit(IDLE)


## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	unit.unit_animation.set_condition("parameters/UnitState/conditions/move", false)
	if is_instance_valid(construction_target):
		construction_target.assigned_units.erase(unit)
	pass
