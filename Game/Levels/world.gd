extends Node2D

class_name Level

@export var selection_feather = 200

@onready var game_resources = GameInventory
@onready var ui = $UI
@onready var control_grid = %ControlGrid
@onready var unit_portrait_grid = %UnitPortraitGrid

var is_selecting = false
var selector_origin : Vector2
var selector_rect : Rect2
@onready var selector_rect_fill : ColorRect = %SelectorRect

# unit_portrait array variables
var unit_portrait_owners : Array
var unit_portrait_dict : Dictionary

func _ready():
	add_to_group("Level")

func _process(delta):
	ui.update_resource_labels(str(game_resources.game_resources_dictionary))
	
		


func _unhandled_input(event):
	if Input.is_action_just_pressed("select"):
			# Start drawing the rectangle selector
		is_selecting = true
		selector_origin = get_global_mouse_position()
		selector_rect = Rect2(selector_origin, selector_origin)
		selector_rect_fill.visible = true
		selector_rect_fill.position = selector_origin
		
	
	if Input.is_action_pressed("select"):
		var current_mouse_position = get_global_mouse_position()
		var size = current_mouse_position - selector_origin
	
		# Handle flipping the rectangle selector
		selector_rect.position = Vector2(
			min(selector_origin.x, current_mouse_position.x), 
			min(selector_origin.y, current_mouse_position.y)
		)
		selector_rect.size = Vector2(
			abs(current_mouse_position.x - selector_origin.x),
			abs(current_mouse_position.y - selector_origin.y)
		)
		
		# Update the UI rectangle
		selector_rect_fill.position = selector_rect.position
		selector_rect_fill.size = selector_rect.size

	if Input.is_action_just_released("select"):
		# Stop drawing the rectangle
		is_selecting = false
		selector_rect_fill.visible = false
		# Get units in the selector rectangle
		var units_in_selector_rect : Array[Unit]
		var all_units = get_tree().get_nodes_in_group("Unit")
		if selector_rect.size.x > selection_feather or selector_rect.size.y > selection_feather:
			for unit in all_units:
				if selector_rect.has_point(unit.global_position):
					units_in_selector_rect.append(unit)
		else:
			var click_location = get_global_mouse_position()
			var closest_unit = GlobalFunctions.get_closest_unit_to_location("Unit",click_location)
			
			if click_location.distance_to(closest_unit.global_position) >= selection_feather :
				print("No unit close to click location to select")
				pass
			else:
				units_in_selector_rect.append(closest_unit)
		
		if units_in_selector_rect.size() > 1:
			if Input.is_action_pressed("shift"):
				for unit in units_in_selector_rect:
					if not unit.unit_stats.is_selectable or unit.unit_stats.allegiance != "Player":
						continue
					unit.select()
			else:
				for unit in all_units:
					unit.deselect()
				for unit in units_in_selector_rect:
					if not unit.unit_stats.is_selectable or unit.unit_stats.allegiance != "Player":
						continue
					unit.select()

					
		if units_in_selector_rect.size() <= 1:
			for unit in units_in_selector_rect:
				if not unit.unit_stats.is_selectable:
					continue
					
				if unit.is_selected == false:
					if Input.is_action_pressed("shift"):
						unit.select()
					else:
						for checked_unit in get_tree().get_nodes_in_group("Selected"):
							checked_unit.deselect()
						unit.select()
				elif unit.is_selected == true:
					if Input.is_action_pressed("shift"):
						unit.deselect()
					else:
						for checked_unit in get_tree().get_nodes_in_group("Selected"):
							checked_unit.deselect()
						unit.select()
		update_ui()
		selector_rect.size = Vector2(0,0)

	if Input.is_action_just_pressed("move_to"):
		var selected_units = get_tree().get_nodes_in_group("Selected")
		var click_position = get_global_mouse_position()
		# Remove units that cannot move and get group centre position
		var moveable_units = selected_units
		
		for unit in selected_units:
			if unit.unit_stats.can_move == false:
				moveable_units.erase(unit)
				print(unit.name + " cannot move.")
		# Get offsetted move target
		var move_target_dict = get_offsetted_position(moveable_units, click_position)
		var unit_closest_to_centre = moveable_units[0]
		for unit in moveable_units:
			var distance_to_centre = unit.global_position.distance_squared_to(click_position)
			if distance_to_centre < unit_closest_to_centre.global_position.distance_squared_to(click_position):
				unit_closest_to_centre = unit
		unit_closest_to_centre.state_machine._transition_to_next_state("Moving",{"MoveTarget" : click_position})
		moveable_units.erase(unit_closest_to_centre)
		for unit in moveable_units:
			var move_target = move_target_dict.get(unit)
			unit.state_machine._transition_to_next_state("Moving",{"MoveTarget" : move_target})
				
		# Set each unit's target move position based on mouse position and offset from base position
	
	if Input.is_action_just_pressed("stop"):
		var selected_units = get_tree().get_nodes_in_group("Selected")
		for unit in selected_units:
			if unit.state_machine:
				unit.state_machine._transition_to_next_state("Idle")
	
	if Input.is_action_just_pressed("attack"):
		var selected_units = get_tree().get_nodes_in_group("Selected")
		var mouse_position = get_global_mouse_position()
		var closest_unit = GlobalFunctions.get_closest_unit_to_location("Unit", mouse_position)
		
		if closest_unit.position.distance_to(mouse_position) <= selection_feather:
			for unit in selected_units:
				if unit != closest_unit: 
					if unit.state_machine:
						unit.state_machine._transition_to_next_state("Attacking", {"AttackTarget" : closest_unit})
		else:
			var moveable_units : Array
			for unit in selected_units:
				if unit.unit_stats.can_move == true:
					moveable_units.append(unit)
			# Set attack move targets with offset
			var attack_move_target_dict = get_offsetted_position(moveable_units, mouse_position)
			for unit in selected_units:
				if unit.state_machine:
					var offset_attack_move_position : Vector2 = attack_move_target_dict.get(unit)
					unit.state_machine._transition_to_next_state("AttackMove", {"AttackMoveTargetPosition" : offset_attack_move_position})
	 
	#if Input.is_action_just_pressed("produce_unit"):
		#var selected_units = get_tree().get_nodes_in_group("Selected")
		#for unit in selected_units:
			#if unit.producer_component:
				#unit.producer_component.init_production(null)

## Debug
	if Input.is_action_just_pressed("print_scene_tree"):
		print_tree_pretty()
		print_orphan_nodes()
	
	if Input.is_action_just_pressed("cheat_resources"):
		game_resources.add_resources("Gold", 200)
		game_resources.add_resources("Meat", 200)
		game_resources.add_resources("Wood", 200)
		print(game_resources.game_resources_dictionary)
		pass

func get_offsetted_position(unit_group,target_position) -> Dictionary:
	# Set target position based on offsetting units based on their direction from the centre of the group.
	var positions_dictionary : Dictionary = {}
	var unit_selection_centre : Vector2
	if unit_group.size() > 0:
		unit_selection_centre = unit_group[0].global_position
	for unit in unit_group:
		unit_selection_centre = unit.global_position.lerp(unit_selection_centre,0.5)
	for unit in unit_group:
		var move_offset_direction = unit_selection_centre.direction_to(unit.global_position)
		var offsetted_target_position = target_position + move_offset_direction * Vector2(50,50)
		positions_dictionary.merge({
			unit : offsetted_target_position
		})
	return positions_dictionary
		


## Updates all UI elements.
func update_ui():
	update_control_grid_ui()
	update_selected_units_ui()

## Updates the control grid UI.
func update_control_grid_ui():
	# Clear Control Grid UI
	for child in control_grid.get_children():
		control_grid.remove_child(child)
		child.queue_free()
		
	# Get UI elements from selected units
	var selected_units = get_tree().get_nodes_in_group("Selected")
	var button_id_list : Array
	for unit in selected_units:
		if unit.control_grid_component:
			for button : ControlGridButton in unit.control_grid_component.buttons:
				# Ensures no duplicate buttons in the control list.
				if not button_id_list.has(button.button_id):
					button_id_list.append(button.button_id)
					var new_button = button.duplicate()
					control_grid.add_child(new_button)
					if new_button is ProduceButton:
						new_button.production_button_pressed.connect(_on_production_button_pressed)
					if new_button is RallyPointButton:
						new_button.rally_button_pressed.connect(_on_rally_button_pressed)
					if new_button is CommandButton:
						new_button.command_button_pressed.connect(_on_command_button_pressed)
				else:
					continue

## Update Selected Unit UI.
func update_selected_units_ui():
	# "Owner" "Reparented Node"
	var n : int = 0

	# Return unit portraits to respectful unit_portrait owners
	for unit in unit_portrait_owners:
		if is_instance_valid(unit):
			var reparented_portrait = unit_portrait_dict.get(unit)
			if reparented_portrait:
				reparented_portrait.reparent(unit)
				reparented_portrait.visible = false
		if not is_instance_valid(unit):
			unit_portrait_dict.get(unit).queue_free()
		
	unit_portrait_owners.clear()
	unit_portrait_dict.clear()
	# Reparent unit portraits
	var selected_units = get_tree().get_nodes_in_group("Selected")
	var unit_portraits
	for unit in selected_units:
		if unit.unit_portrait:
			var portrait = unit.unit_portrait
			portrait.visible = true
			portrait.reparent(unit_portrait_grid)
			unit_portrait_owners.append(unit)
			unit_portrait_dict.merge({
				unit : portrait
				})
	
			# save which units are which unit portrait
	pass


## Called when production button is pressed. Checks for the producer unit with the least amount of units queued then adds the unit to queue. Produced unit is set in the production componenent of the Unit.
func _on_production_button_pressed(produced_unit):
	var selected_units = get_tree().get_nodes_in_group("Selected")
	var selected_producer_units : Array
	for unit in selected_units:
		if unit.producer_component:
			selected_producer_units.append(unit)
	var least_busy_producer = selected_producer_units.front()
	for unit in selected_producer_units:
		if unit.producer_component.units_queued < least_busy_producer.producer_component.units_queued:
			least_busy_producer = unit
	least_busy_producer.producer_component.init_production(produced_unit)

## Called when rally button is pressed.
func _on_rally_button_pressed(rally_point):
	var selected_units = get_tree().get_nodes_in_group("Selected")
	for unit : Unit in selected_units:
		if unit.producer_component:
			var mouse_location = get_global_mouse_position()
			var rally_point_instance = RallyPoint.new(unit.producer_component,mouse_location)
			
func _on_command_button_pressed(commanded_state, target):
	var selected_units = get_tree().get_nodes_in_group("Selected")
	for unit : Unit in selected_units:
		if unit.state_machine.has_state(commanded_state):
			if target is Vector2:
				match commanded_state:
					"Move":
						unit.state_machine._transition_to_next_state(commanded_state,{"MoveTarget":target})
					"AttackMove":
						unit.state_machine._transition_to_next_state(commanded_state,{"AttackMoveTargetPosition":target})
			elif target is Unit:
				match commanded_state:
					"Building":
						unit.state_machine._transition_to_next_state(commanded_state,{"BuildTarget":target})
					"Attack":
						unit.state_machine._transition_to_next_state(commanded_state,{"AttackTarget":target})
			else:
				unit.state_machine._transition_to_next_state(commanded_state)
