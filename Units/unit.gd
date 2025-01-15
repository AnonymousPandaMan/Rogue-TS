extends CharacterBody2D

class_name Unit

## All unit stats, flags and assets stored in a UnitStats resource. This asks for a UnitStats resource then duplicates it to avoid changing all stats of same unit type at once.
@export var unit_stats_resource : UnitStats 
@onready var unit_stats : UnitStats = unit_stats_resource.duplicate()


## Exported refences to nodes here.
@export var debug_label: Label ## Optional. Debug unit states
@export var state_machine: StateMachine ## StateMachine controls unit states and actions.
@export var producer_component: ProducerComponent ## Optional. Producer component which creates units.
@export var scanner_component: ScannerComponent ## Required for units to be able to scan for enemies/targets.
@export var control_grid_component: ControlGridComponent ## For Units that have special actions that need to be displayed on the control grid.
@export var unit_animation : UnitAnimationComponent ## Unit Animation Holder
@export var health_bar_component : HealthBarComponent ## Healthbar

## Exported references to non-node resources here.
@export var selected_outline : ShaderMaterial

var is_selected := false

func _ready():
	if unit_stats:
		unit_stats.health = unit_stats.max_health
		if unit_stats.unit_name:
			name = unit_stats.unit_name
		if unit_stats.is_building == true:
			add_to_group("Building")
		add_to_group(unit_stats.allegiance)
		add_to_group("Unit")
	
	
	
	if scanner_component:
		scanner_component.get_node("ScanArea").shape.set_radius(unit_stats.attack_range+200)
	#Errors for missing references
	if not state_machine:
		printerr("StateMachine not found for " + name)
	if not unit_animation:
		printerr("Sprite/UnitAnimation not found for " + name)
	if not scanner_component:
		printerr("ScannerComponent not found for " + name + " if this is not intentional, check that it has been assigned in the Inspector")

	## Signal Connections
	unit_stats.health_changed.connect(on_health_changed)

func select():
	is_selected = true
	#print(name + " is selected.")
	if selected_outline:
		unit_animation.unit_sprite.material =  selected_outline
	add_to_group("Selected")

func deselect():
	is_selected = false
	#print(name + " is deselected.")
	if selected_outline:
		unit_animation.unit_sprite.material = null
	remove_from_group("Selected")

func take_damage(amount: int):
	unit_stats.health -= amount


func die():
	print(name + " has died.")
	queue_free() # deletes this node

func enemy(my_allegiance : String):
	if my_allegiance == "Ally":
		return ["Neutral", "Enemy"]
	if my_allegiance == "Enemy":
		return ["Ally", "Neutral","Player"]
	if my_allegiance == "Neutral":
		return ["Ally", "Enemy", "Player"]
	if my_allegiance == "Player":
		return ["Neutral", "Enemy"]

func is_enemy(my_allegiance : String):
	if my_allegiance == "Ally":
		if unit_stats.allegiance == "Neutral" or unit_stats.allegiance == "Enemy":
			return true
		else:
			return false
	if my_allegiance == "Enemy":
		if unit_stats.allegiance == "Neutral" or unit_stats.allegiance == "Ally":
			return true
		else:
			return false
	
	if my_allegiance == "Neutral":
		if unit_stats.allegiance == "Enemy" or unit_stats.allegiance == "Ally":
			return true
		else:
			return false

func on_health_changed(health):
	var health_decimal := unit_stats.health/unit_stats.max_health
	health_bar_component.value = health_decimal * 100
	if unit_stats.health < unit_stats.max_health:
		health_bar_component.visible = true
	if unit_stats.health <= 0:
		die()
