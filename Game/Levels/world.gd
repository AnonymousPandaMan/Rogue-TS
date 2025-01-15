extends Node2D

class_name Level

@export var selection_feather = 200

@onready var game_resources = GameInventory
@onready var ui = $UI
@onready var control_grid = %ControlGrid

func _process(delta):
	ui.update_resource_labels(str(game_resources.game_resources_dictionary))

func _unhandled_input(event):
	if Input.is_action_just_pressed("select"):
		var click_location = get_global_mouse_position()
		var closest_unit = GlobalFunctions.get_closest_unit_to_location("Unit",click_location)
		if click_location.distance_to(closest_unit.global_position) <= selection_feather :
			if closest_unit.is_selected == false:
				if Input.is_action_pressed("shift"):
					pass
				else:
					for unit in get_tree().get_nodes_in_group("Selected"):
						unit.deselect()
				closest_unit.select()
			elif closest_unit.is_selected == true:
				if Input.is_action_pressed("shift"):
					closest_unit.deselect()
				else:
					for unit in get_tree().get_nodes_in_group("Selected"):
						unit.deselect()
					closest_unit.select()
			update_control_grid_ui()
		else:
			print("No unit close to click location to select")
		
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
					unit.state_machine._transition_to_next_state("Attacking", {"AttackTarget" : closest_unit})
		else:
			for unit in selected_units:
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
