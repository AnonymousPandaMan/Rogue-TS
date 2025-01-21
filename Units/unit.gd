extends CharacterBody2D

class_name Unit

signal navigation_refeshed()
signal health_percent_changed(percentage)

## All unit stats, flags and assets stored in a UnitStats resource. This asks for a UnitStats resource then duplicates it to avoid changing all stats of same unit type at once.
@export var unit_stats_resource : UnitStats 
@onready var unit_stats : UnitStats = unit_stats_resource.duplicate()


## Exported refences to nodes here.
@export_group("Components and Nodes")
@export_subgroup("Required")
@export var state_machine: StateMachine ## StateMachine controls unit states and actions.
@export var navigation_component: NavigationComponent ## Nav component for navigation
@export var unit_animation : UnitAnimationComponent ## Unit Animation Holder

@export_subgroup("Optional")
@export var debug_label: Label ## Optional. Debug unit states
@export var health_bar_component : HealthBarComponent ## Healthbar. Use if unit has health.
@export var producer_component: ProducerComponent ## Optional. Producer component which creates units.
@export var control_grid_component: ControlGridComponent ## For Units that have special actions that need to be displayed on the control grid.
@export var unit_finder_component: UnitFinderComponent ## Required for units to be able to scan for enemies/targets.
@export var builder_component: BuilderComponent

## Exported references to non-node resources here.
@export_group("Resources")
@export var selected_outline : ShaderMaterial

@onready var unit_portrait = $UnitPortrait

var is_selected := false
var requested_navigation_target_position : Vector2

var previous_health

# variables for the state machines functionality


func _ready():
	if unit_stats:
		unit_stats.health = unit_stats.max_health
		if unit_stats.unit_name:
			name = unit_stats.unit_name
		if unit_stats.is_building == true:
			add_to_group("Building")
		add_to_group(unit_stats.allegiance)
		add_to_group("Unit")
	
	#Errors for missing references
	if not state_machine:
		printerr("StateMachine not found for " + name)
	if not unit_animation:
		printerr("Sprite/UnitAnimation not found for " + name)
	if not unit_finder_component:
		printerr("UnitFinderComponent not found for " + name + " if this is not intentional, check that it has been assigned in the Inspector")

	## Signal Connections
	# Connect health changed signal (emitted from unit_stats)
	unit_stats.health_changed.connect(on_health_changed)
	if unit_portrait:
		unit_stats.health_changed.connect(unit_portrait._on_unit_health_percentage_changed)
	# Connect navigation component signal
	if navigation_component:
		navigation_component.refresh_timer.timeout.connect(on_refresh_timer_timeout)
	
	# Other assigns
	if unit_stats.unit_portrait:
		unit_portrait.sprite.set_texture(unit_stats.unit_portrait) 
	
	# Function inits.
	previous_health = unit_stats.health
	
	# Visibility
	if unit_animation:
		unit_animation.visible = true
	
	if control_grid_component:
		control_grid_component.visible = false # control grid is hidden until needed

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
	unit_portrait.visible = false
	state_machine.state.exit() # cleans up any final state stuff
	var on_death_scene = load(unit_stats.on_death)
	var on_death = on_death_scene.instantiate()
	var level_node = get_tree().get_first_node_in_group("Level")
	level_node.add_child(on_death)
	on_death.global_position = global_position
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
	var health_percentage = health_decimal * 100
	health_percent_changed.emit(health_percentage)
	health_bar_component.value = health_percentage
	if unit_stats.health < unit_stats.max_health:
		health_bar_component.visible = true
	if unit_stats.health <= 0:
		die()
	
	if health - previous_health < 0:
		do_flash(Color.ORANGE_RED)
	elif health - previous_health > 0:
		do_flash(Color.GREEN)

func on_refresh_timer_timeout():
	## Update Navigation
	if requested_navigation_target_position:
		navigation_component.nav.target_position = requested_navigation_target_position
		navigation_refeshed.emit()

func do_flash(color:Color):
	if not unit_stats.is_building:
		modulate = color
		await get_tree().create_timer(0.1).timeout
		modulate = Color.WHITE
