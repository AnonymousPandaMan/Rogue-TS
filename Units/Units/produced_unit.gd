extends Node

class_name ProducedUnit

@export_file("*.tscn") var unit_scene: String 

@export var unit_stats : UnitStats

@export var unit_primary_resource_cost : int
@export var unit_secondary_resource_cost : int

@export var unit_production_time : float = 10
