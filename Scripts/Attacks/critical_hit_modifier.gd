extends AttackModifier

class_name CriticalHitModifier

var crit_multiplier: float = 2.0

func _init(crit_multiplier: float = 2.0):
	self.crit_multiplier = crit_multiplier

func apply(damage: int) -> int:
	return int(damage * crit_multiplier)
