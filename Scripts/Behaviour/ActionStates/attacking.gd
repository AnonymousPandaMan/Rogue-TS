extends UnitState

var attack_target = null
var attack_move_target_position
var can_attack = true
var currently_attacking = false
var attack
var current_attack_time 
var attack_time 
## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	if currently_attacking == true:
		attack_timer(_delta)
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	if is_instance_valid(attack_target):
		unit.move_and_slide()
		if unit.position.distance_to(attack_target.position) <= unit.unit_stats.attack_range:
			unit.velocity = Vector2.ZERO
			if can_attack == true:
				can_attack = false
				attack_time = 1/unit.unit_stats.attack_speed
				current_attack_time = attack_time
				currently_attacking = true
				attack = Attack.new(unit,attack_target,unit.unit_stats.attack_damage,unit.unit_stats.attack_range)
				
				# change facing direction
				var facing_direction = unit.position.direction_to(attack_target.position)
				unit.unit_animation.unit_animation_tree.set("parameters/UnitState/Attack/blend_position",facing_direction)
				
				# apply animation time scale
				var attack_speed_corrected_animation_time_scale = unit.unit_stats.attack_animation_time/attack_time
				unit.unit_animation.unit_animation_tree.set("parameters/TimeScale/scale", attack_speed_corrected_animation_time_scale)

		if unit.position.distance_to(attack_target.position) > unit.unit_stats.attack_range and currently_attacking == false:
			finished.emit(MOVETOATTACK,{"AttackTarget" : attack_target, "AttackMoveTargetPosition" : attack_move_target_position})
	else:
		if currently_attacking == false:
			if attack_move_target_position:
				finished.emit(ATTACKMOVE, {"AttackMoveTargetPosition" : attack_move_target_position})
			else:
				finished.emit(IDLE)
## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	unit.unit_animation.unit_animation_tree.set("parameters/UnitState/conditions/attack", true)

	if data:
		attack_target = data.get("AttackTarget")
		attack_move_target_position = data.get("AttackMoveTargetPosition")
		#print(str(attack_target))

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	unit.unit_animation.unit_animation_tree.set("parameters/UnitState/conditions/attack", false)
	unit.unit_animation.unit_animation_tree.set("parameters/TimeScale/scale", 1)
	current_attack_time = attack_time
	currently_attacking = false
	can_attack = true

func handle_attack():
	can_attack = true
	currently_attacking = false
	current_attack_time = attack_time
	match unit.unit_stats.ranged_or_melee:
		"Ranged":
			var ranged_projectile = RangedProjectile.new(unit,attack_target,unit.unit_stats.ranged_projectile_speed,unit.unit_stats.ranged_projectile_size_modifier,unit.unit_stats.ranged_projectile_sprite)
			get_node("/root/Level").add_child(ranged_projectile)
			await ranged_projectile.reached_target
			attack.execute()
		"Melee":
			attack.execute()

func attack_timer(_delta):
	current_attack_time -= _delta
	if current_attack_time <= 0:
		handle_attack()
	
	
