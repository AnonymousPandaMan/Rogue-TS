extends Node2D

class_name Level

@export var selection_feather = 200

@onready var game_resources = GameInventory
@onready var ui = $UI
@onready var control_grid = %ControlGrid

var is_selecting = false
var selector_origin : Vector2
var selector_rect : Rect2
@onready var selector_rect_fill : ColorRect = %SelectorRect

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
		print(str(selector_rect))
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
		update_control_grid_ui()
		selector_rect.size = Vector2(0,0)

	if Input.is_action_just_pressed("move_to"):
		var selected_units = get_tree().get_nodes_in_group("Selected")
		for unit in selected_units:
			if unit.unit_stats.can_move == true:
				var click_position = get_global_mouse_position()
				unit.state_machine._transition_to_next_state("Moving",{"MoveTarget" : click_position})
			else:
				print(unit.name + " cannot move.")
	
	if Input.is_action_just_pressed("stop"):
		var selected_units = get_tree().get_nodes_in_group("Selected")
		for unit in selected_units:
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
			for unit in selected_units:
				if unit.state_machine:
					unit.state_machine._transition_to_next_state("AttackMove", {"AttackMoveTargetPosition" : mouse_position})
	 
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
		print(game_resources.game_resources_dictionary)
		pass

## Updates the control grid UI.
func update_control_grid_ui():
	# Clear Control Grid UI
	for child in control_grid.get_children():
		control_grid.remove_child(child)
		child.queue_free()
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
				else:
					continue



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

func _on_rally_button_pressed(rally_point):
	var selected_units = get_tree().get_nodes_in_group("Selected")
	for unit : Unit in selected_units:
		if unit.producer_component:
			var mouse_location = get_global_mouse_position()
			var rally_point_instance = RallyPoint.new(unit.producer_component,mouse_location)
