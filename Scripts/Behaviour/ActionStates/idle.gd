extends UnitState


func enter(previous_state_path: String, data := {}) -> void:
	var facing_direction = unit.velocity.normalized()
	if unit.unit_animation:
		unit.unit_animation.set_condition("parameters/UnitState/conditions/idle", true)
		unit.unit_animation.set_blend_position("parameters/UnitState/Idle/blend_position",facing_direction.x)
	unit.velocity = Vector2(0,0)
	unit.attacked.connect(_on_attacked)

func physics_update(_delta: float) -> void:
	if unit.unit_stats.can_move == true:
		unit.move_and_slide()
	if unit.unit_finder_component and not unit.unit_stats.is_passive:
		var enemy_array = unit.enemy(unit.unit_stats.allegiance)
		var target_unit
		for enemy in enemy_array:
			target_unit = unit.unit_finder_component.get_closest_unit(enemy)
		if target_unit:
			var target_range = unit.unit_stats.aggro_range
			if target_unit.position.distance_to(unit.position) < target_range:
				finished.emit(MOVETOATTACK,{"AttackTarget" : target_unit})
			else:
				target_unit = null
func exit() -> void:
	if unit.unit_animation:
		unit.unit_animation.set_condition("parameters/UnitState/conditions/idle", false)
	unit.attacked.disconnect(_on_attacked)

func _on_attacked(by_unit : Unit):
	if is_instance_valid(by_unit):
		if unit.global_position.distance_to(by_unit.global_position) < unit.unit_stats.aggro_range * 2 and not unit.unit_stats.is_passive:
			finished.emit(MOVETOATTACK,{"AttackTarget" : by_unit})
		else:
			pass
			# flee 
