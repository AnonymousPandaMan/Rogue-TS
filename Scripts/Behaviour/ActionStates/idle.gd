extends UnitState


func enter(previous_state_path: String, data := {}) -> void:
	var facing_direction = unit.velocity.normalized()
	unit.unit_animation.unit_animation_tree.set("parameters/UnitState/conditions/idle", true)
	unit.unit_animation.unit_animation_tree.set("parameters/UnitState/Idle/blend_position",facing_direction.x)
	unit.velocity = Vector2(0,0)
func physics_update(_delta: float) -> void:
	if unit.unit_stats.can_move == true:
		unit.move_and_slide()
	var enemy_array = unit.enemy(unit.unit_stats.allegiance)
	for enemy in enemy_array:
		var target_unit = unit.unit_finder_component.get_closest_unit(enemy)
		if target_unit:
			var target_range = unit.unit_stats.attack_range + 200
			if target_unit.position.distance_to(unit.position) < target_range:
				finished.emit(MOVETOATTACK,{"AttackTarget" : target_unit})
func exit() -> void:
	unit.unit_animation.unit_animation_tree.set("parameters/UnitState/conditions/idle", false)
	pass
