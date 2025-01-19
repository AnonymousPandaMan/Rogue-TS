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
		
@export var health_regen := 10.0
@export var armour := 1.0
@export_subgroup("Attack Stats")
@export var attack_damage := 10.0
@export var attack_speed := 1/0.6 ## attacks per second
@export var attack_animation_time := 0.8 ## time to finish attack animation in seconds
@export var attack_range:= 200.0 ## maximal distance from target to initiate an attack
@export var ranged_projectile_speed : float = 500
@export var ranged_projectile_size_modifier : float = 1
@export var ranged_projectile_sprite : Texture2D = AtlasTexture.new()

@export_group("Unit Flags")
@export_enum("Ranged","Melee") var ranged_or_melee : String
@export_enum("Light", "Medium", "Armoured") var armour_type : String
@export var is_selectable := true ## non-functional atm
@export var is_controllable := true ## non-functional atm
@export var is_building := false ## non-functional atm
@export var can_move := true

@export_subgroup("Unit Allegiance")
@export_enum("Ally","Player","Enemy","Neutral") var allegiance : String = "Neutral"

@export_group("Unit Assets")
