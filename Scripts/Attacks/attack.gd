extends Object

class_name Attack

var base_damage: int
var attacker: Unit
var target: Unit
var attack_range: float
var modifiers: Array = [] # Add modifiers on later

# Constructor for initializing attack details
func _init(attacker: Unit, target: Unit, base_damage: int, attack_range: float):
	self.attacker = attacker
	self.target = target
	self.base_damage = base_damage
	self.attack_range = attack_range

# Method to execute the attack
func execute():
	#if not attacker.is_alive or not target.is_alive:
		#return

	if is_in_range():
		var final_damage = calculate_damage()
		target.take_damage(final_damage)
		print(attacker.name + " attacked " + target.name + " for " + str(final_damage) + " damage!")
	else:
		print("Target out of range.")

# Check if the target is within the attacker's range
func is_in_range() -> bool:
	if is_instance_valid(target):
		return attacker.global_position.distance_to(target.global_position) <= attack_range*2
	else:
		return false

# Calculate the damage with modifiers
func calculate_damage() -> int:
	var damage = base_damage - target.unit_stats.armour
	if damage < 0:
		damage = 0

	# Apply any modifiers to the damage
	for modifier in modifiers:
		damage = modifier.apply(damage)

	return damage
