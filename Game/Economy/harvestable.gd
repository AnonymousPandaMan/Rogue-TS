class_name Harvestable
extends StaticBody2D

@export_enum("Wood","Gold","Meat") var resource_harvested : String
@export var base_amount : int = 100
@export var harvesting_multiplier := 1.0
@export var max_harvesters := 1

var amount_remaining : int
var being_harvested : bool
var level
var harvesters_list : Array = []
var harvesters_amount : int

signal too_many_harvesters(removed_harvester)


func _process(delta):
	if harvesters_list.size() > 0:
		if harvesters_amount > max_harvesters:
			var declined_harvester = harvesters_list.front()
			too_many_harvesters.emit(declined_harvester)
			

func _ready():
	add_to_group("Harvestable")
	amount_remaining = base_amount
	level = get_tree().get_first_node_in_group("Level")

func being_harvested_animation(_bool):
	if _bool:
		$AnimatedSprite2D.play("harvested")
	else:
		$AnimatedSprite2D.play("idle")

func declare_harvester(unit, _bool : bool):
	if _bool:
		if not harvesters_list.has(unit):
			harvesters_list.append(unit)
			harvesters_amount = harvesters_list.size()
			if harvesters_amount > 0:
				being_harvested_animation(true)
	if not _bool:
		if harvesters_list.has(unit):
			harvesters_list.erase(unit)
			harvesters_amount = harvesters_list.size()
			if harvesters_amount == 0:
				being_harvested_animation(false)
		

func set_timescale(timescale):
	$AnimatedSprite2D.speed_scale = timescale

func _on_harvested(amount):
	amount_remaining -= amount
	if amount_remaining <= 0:
		level.nav_region.bake_navigation_polygon()
		queue_free()
