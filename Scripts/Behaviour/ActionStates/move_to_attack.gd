extends UnitState

var attack_target = null
var can_attack = true
var attack_move_target_position

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	if is_instance_valid(attack_target):
		unit.move_and_slide()
		if unit.position.distance_to(attack_target.position) <= unit.unit_stats.attack_range:
			finished.emit(ATTACKING, {"AttackTarget" : attack_target, "AttackMoveTargetPosition" : attack_move_target_position})
		if unit.position.distance_to(attack_target.position) > unit.unit_stats.attack_range - 20:
			var attack_target_position = (attack_target.position - unit.position).normalized()
			unit.velocity = attack_target_position * unit.unit_stats.move_speed
			var facing_direction = unit.velocity.normalized()
			unit.unit_animation.set_blend_position("parameters/UnitState/Move/blend_position",facing_direction.x)
	else:
		finished.emit(IDLE)
## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	if data:
		attack_target = data.get("AttackTarget")
		attack_move_target_position = data.get("AttackMoveTargetPosition")
	unit.unit_animation.set_condition("parameters/UnitState/conditions/move", true)
## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	unit.unit_animation.set_condition("parameters/UnitState/conditions/move", false)
