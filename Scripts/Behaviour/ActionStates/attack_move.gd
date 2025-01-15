extends UnitState

var attack_move_target_position : Vector2
var attack_move_target_unit : Unit

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	unit.move_and_slide()
	var enemy_array = unit.enemy(unit.unit_stats.allegiance)
	for enemy in enemy_array:
		attack_move_target_unit = unit.unit_finder_component.get_closest_unit(enemy)
		if attack_move_target_unit:
			var target_range = unit.unit_stats.attack_range + 200
			if attack_move_target_unit.position.distance_to(unit.position) < target_range:
				finished.emit(MOVETOATTACK,{"AttackMoveTargetPosition" : attack_move_target_position,"AttackTarget" : attack_move_target_unit})
	if unit.position.distance_to(attack_move_target_position) >= 10:
		var target_direction = (attack_move_target_position - unit.position).normalized()
		unit.velocity = target_direction * unit.unit_stats.move_speed
		var facing_direction = unit.velocity.normalized()
		unit.unit_animation.set_blend_position("parameters/UnitState/Move/blend_position",facing_direction.x)
	else:
		finished.emit(IDLE)
## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	unit.unit_animation.set_condition("parameters/UnitState/conditions/move", true)
	if data:
		attack_move_target_position = data.get("AttackMoveTargetPosition")
	else:
		finished.emit(IDLE)
## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	attack_move_target_unit = null
	unit.unit_animation.set_condition("parameters/UnitState/conditions/move", false)
	pass
