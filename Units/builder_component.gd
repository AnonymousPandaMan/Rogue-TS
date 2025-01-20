class_name BuilderComponent
extends Node2D



func _ready():
	pass

func init_building(unit : BuiltUnit):
	var cost1 = unit.unit_costs.wood_cost
	var cost2 = unit.unit_costs.meat_cost
	var cost3 = unit.unit_costs.gold_cost
	if GameInventory.has_enough_resources("Wood",cost1) and GameInventory.has_enough_resources("Meat",cost2) and GameInventory.has_enough_resources("Gold",cost3):
		GameInventory.change_resource_amount("Wood", -cost1)
		GameInventory.change_resource_amount("Meat", -cost2)
		GameInventory.change_resource_amount("Gold", -cost3)
