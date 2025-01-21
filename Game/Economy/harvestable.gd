class_name Harvestable
extends AnimatedSprite2D

@export_enum("Wood","Gold","Meat") var resource_harvested : String
@export var base_amount : int = 100
@export var harvesting_multiplier := 1.0

var amount_remaining


func _ready():
	add_to_group("Harvestable")
	amount_remaining = base_amount

func _on_harvested(amount):
	amount_remaining -= amount
	if amount_remaining <= 0:
		queue_free()
