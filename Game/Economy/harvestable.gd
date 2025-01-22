class_name Harvestable
extends StaticBody2D

@export_enum("Wood","Gold","Meat") var resource_harvested : String
@export var base_amount : int = 100
@export var harvesting_multiplier := 1.0

var amount_remaining
var being_harvested

func _ready():
	add_to_group("Harvestable")
	amount_remaining = base_amount

func toggle_being_harvested(_bool):
	if _bool:
		being_harvested = true
		$AnimatedSprite2D.play("harvested")
	else:
		being_harvested = false
		$AnimatedSprite2D.play("idle")

func set_timescale(timescale):
	$AnimatedSprite2D.speed_scale = timescale

func _on_harvested(amount):
	amount_remaining -= amount
	if amount_remaining <= 0:
		queue_free()
 
