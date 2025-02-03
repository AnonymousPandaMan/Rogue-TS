class_name StatItem
extends Item

@export var affected_unit_classes : String ##Comma separated list of affected unit class groups.
@export_enum("Percentage","Flat Increase") var percentage_or_flat : String

enum stats_list {HEALTH, ATTACK_SPEED, ATTACK_DAMAGE, MOVE_SPEED, ATTACK_RANGE, HARVEST_POWER, HARVEST_SPEED}
@export var stat_changed : stats_list
@export var stat_change_amount : float = 0
@export var stat2_changed : stats_list
@export var stat2_change_amount : float = 0
@export var stat3_changed : stats_list
@export var stat3_change_amount : float = 0

# formatts description to auto populate the stat change amount
func formatted_description():
	if "%s".is_subsequence_of(item_description):
		var replacement_text = str(stat_change_amount)
		if percentage_or_flat == "Percentage":
			replacement_text = str(stat_change_amount) + "%"
		var formatted_item_description = item_description % replacement_text
		return formatted_item_description
	else:
		return item_description

func apply_all_properties(unit : Unit):
	apply_properties(unit, stat_changed,stat_change_amount)
	apply_properties(unit, stat2_changed,stat2_change_amount)
	apply_properties(unit, stat3_changed,stat3_change_amount)

func apply_properties(unit : Unit, _stat_changed, amount):
	if is_affected(unit):
		if percentage_or_flat == "Flat Increase" or null:
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

		elif percentage_or_flat == "Percentage":
			var percent_amount = amount / 100
			match _stat_changed:
				stats_list.HEALTH:
					var change_amount = unit.unit_base_stats.max_health * percent_amount
					unit.unit_stats.max_health += change_amount
					unit.unit_stats.health += change_amount
				stats_list.ATTACK_SPEED:
					unit.unit_stats.attack_speed += unit.unit_base_stats.attack_speed * percent_amount
				stats_list.ATTACK_DAMAGE:
					unit.unit_stats.attack_damage += unit.unit_base_stats.attack_damage * percent_amount
				stats_list.MOVE_SPEED:
					unit.unit_stats.move_speed += unit.unit_base_stats.move_speed * percent_amount
				stats_list.ATTACK_RANGE:
					unit.unit_stats.attack_range += unit.unit_base_stats.attack_range * percent_amount
				stats_list.HARVEST_POWER:
					unit.unit_stats.harvest_power += unit.unit_base_stats.harvest_power * percent_amount
				stats_list.HARVEST_SPEED:
					unit.unit_stats.harvest_speed += unit.unit_base_stats.harvest_speed * percent_amount

func is_affected(unit: Unit):
	var space_eliminated_affected_unit_classes = affected_unit_classes.replace(" ","")
	var affected_unit_classes_list = space_eliminated_affected_unit_classes.split(",")
	for group in affected_unit_classes_list:
		if unit.is_in_group(group):
			return true
			
		
