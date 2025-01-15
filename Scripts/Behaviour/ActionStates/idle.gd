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
		var target_unit = unit.scanner_component.get_closest_unit_in_range(enemy)
		if target_unit:
			finished.emit(MOVETOATTACK,{"AttackTarget" : target_unit})

func exit() -> void:
	unit.unit_animation.unit_animation_tree.set("parameters/UnitState/conditions/idle", false)
	pass
