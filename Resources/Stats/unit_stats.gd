class_name UnitStats
extends Resource

signal health_changed(new_health)

@export_group("Identity")
@export var unit_name: String
@export var unit_portrait : Texture2D ## Used to display the unit in the selected units interface.

@export_group("Unit Stats")
@export_subgroup("Defence and Movement Stats")
@export var move_speed := 500.0
@export var max_health := 100.0
var health := max_health:
	set(value):
		health = clamp(value, 0, max_health)
		health_changed.emit(health)
		
@export var health_regen := 0.0
@export var armour := 1.0
@export_subgroup("Attack Stats")
@export var attack_damage := 10.0
@export var attack_speed := 1/0.6 ## attacks per second
@export var attack_animation_time := 0.8 ## time to finish attack animation in seconds
@export var attack_range:= 200.0 ## maximal distance from target to initiate an attack
@export var ranged_projectile_speed : float = 500
@export var ranged_projectile_size_modifier : float = 1

@export_group("Worker Stats")
@export var build_power := 1.0 # multiplier for build speed
@export var build_range := 200 # how far away can i build from
@export var harvest_power := 5 # amount of resources harvest per harvest
@export var harvest_speed := 1.0 # harvest amounts per second is equal to this value divided by the amount of swings to harvest
@export var harvest_swings_required := 3.0 # the amount of animation swings to harvest
@export var harvest_animation_time := 0.6
@export var harvest_range := 200

@export_group("Misc Stats")
@export_range(0,5) var footprint_x := 1 ## Horizontal footprint of build area if building, otherwise area that the unit occupies to block building.
@export_range(0,5) var footprint_y := 1 ## Vertical footprint of build area if building, otherwise area that the unit occupies to block building.

@export_group("Unit Flags")
@export_enum("Ranged","Melee") var ranged_or_melee : String
@export_enum("Light", "Medium", "Armoured") var armour_type : String
@export var is_passive := false ## whether or not this unit actively scans for and attacks enemies.
@export var is_selectable := true ## non-functional atm
@export var is_controllable := true ## non-functional atm
@export var is_building := false ## non-functional atm
@export var is_construction := false ## If the building is a construction site. If true, the unit starts at 10% health and gains health slowly.
@export var can_move := true

@export_subgroup("Unit Allegiance")
@export_enum("Ally","Player","Enemy","Neutral") var allegiance : String = "Neutral"

@export_group("Unit Assets")
@export var ranged_projectile_sprite : Texture2D = AtlasTexture.new()
@export_file("*.tscn") var on_death : String = "res://Units/death_anim.tscn"
