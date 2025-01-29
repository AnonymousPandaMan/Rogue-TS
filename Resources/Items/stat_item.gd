class_name StatItem
extends Item

@export var affected_unit_classes : String ##Comma separated list of affected unit class groups.

enum stats_list {HEALTH, ATTACK_SPEED, ATTACK_DAMAGE, MOVE_SPEED, ATTACK_RANGE, HARVEST_POWER, HARVEST_SPEED}
@export var stat_changed : stats_list
@export var stat_change_amount : float = 0
@export var stat2_changed : stats_list
@export var stat2_change_amount : float = 0
@export var stat3_changed : stats_list
@export var stat3_change_amount : float = 0



func apply_all_properties(unit : Unit):
	apply_properties(unit, stat_changed,stat_change_amount)
	apply_properties(unit, stat2_changed,stat2_change_amount)
	apply_properties(unit, stat3_changed,stat3_change_amount)

func apply_properties(unit : Unit, _stat_changed, amount):
	if is_affected(unit):
		match _stat_changed:
			stats_list.HEALTH:
				unit.unit_stats.max_health += amount
				unit.unit_stats.health += amount
			stats_list.ATTACK_SPEED:
				unit.unit_stats.attack_speed += amount
			stats_list.ATTACK_DAMAGE:
				unit.unit_stats.attack_damage += amount
			stats_list.MOVE_SPEED:
				unit.unit_stats.move_speed += amount
			stats_list.ATTACK_RANGE:
				unit.unit_stats.attack_range += amount
			stats_list.HARVEST_POWER:
				unit.unit_stats.harvest_power += amount
			stats_list.HARVEST_SPEED:
				unit.unit_stats.harvest_speed += amount
		print("Applied item properties " + self.item_name + " to " + unit.name)

func is_affected(unit: Unit):
	var space_eliminated_affected_unit_classes = affected_unit_classes.replace(" ","")
	var affected_unit_classes_list = space_eliminated_affected_unit_classes.split(",")
	for group in affected_unit_classes_list:
		if unit.is_in_group(group):
			return true
			
		
