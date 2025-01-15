extends Node2D

class_name ProducerComponent

##produces all units that are nestled as children under this component.

var units_queued = 0
var current_production_progress = 0.0
var produced_unit 
var producing_unit_node
var production_node_list : Array
var paid_for_production : bool = false

var level_node

var is_producing : bool = false
var unit_scene

var resources_inventory := GameInventory


enum ProductionBehaviour {CYCLE,USER,MOST_EXPENSIVE,LEAST_EXPENSIVE}
@export var production_behaviour : ProductionBehaviour = ProductionBehaviour.CYCLE
@export var spawn_point : SpawnPoint
@export var progress_bar : ProgressBarComponent
@export var rally_point : RallyPoint

func _ready():
	refresh_unit_list()
	if owner.get_parent() is Level:
		level_node = owner.get_parent()
		

func _process(delta):
	if units_queued >= 1:
		is_producing = true
		progress_production(delta)
		if progress_bar:
			if producing_unit_node:
				progress_bar.visible = true
				progress_bar.update_progress_bar(current_production_progress, producing_unit_node.unit_production_time)
	else:
		is_producing = false
		progress_bar.visible = false


func init_production(unit):
	if not unit:
		unit = production_node_list.front()
	var cost1 = unit.unit_primary_resource_cost
	var cost2 = unit.unit_secondary_resource_cost
	if has_enough_resources("Meat",cost1) and has_enough_resources("Gold",cost2):
		pay_for_production("Meat",cost1)
		pay_for_production("Gold",cost2)
		is_producing = true
		units_queued += 1
		if production_behaviour == ProductionBehaviour.USER:
			add_unit_to_queue(unit)
	else:
		print("Not enough resources")
	pass

func add_unit_to_queue(unit) -> void:
	production_node_list.append(unit)
	unit_scene = load(unit.unit_scene)
	print(unit.name + "added to queue")
	pass

func refresh_unit_list() -> void:
	for unit in get_children():
		if unit is ProducedUnit:
			#print("Loaded " + unit.name)
			match production_behaviour:
				ProductionBehaviour.CYCLE:
					add_unit_to_queue(unit)
				ProductionBehaviour.MOST_EXPENSIVE: # to complete
					for checked_unit in production_node_list:
						unit.primary_resource_cost + unit.unit_secondary_resource_cost
				ProductionBehaviour.LEAST_EXPENSIVE: # to complete
					pass
				ProductionBehaviour.USER:
					pass
			pass

func progress_production(amount) -> void:
	if producing_unit_node:
		if current_production_progress >= producing_unit_node.unit_production_time:
			produce_first_unit_in_queue()
			units_queued -= 1
			if units_queued <= 0:
				is_producing = false
		else:
			current_production_progress += amount
			#print(current_production_progress)
		pass
	elif production_node_list:
		producing_unit_node = production_node_list.front()
	
func produce_first_unit_in_queue() -> void:
		var list_front = load(production_node_list.front().unit_scene)
		produced_unit = list_front.instantiate()
		produced_unit.unit_stats = production_node_list.front().unit_stats
		level_node.add_child(produced_unit)
		
		if rally_point:
			produced_unit.state_machine._transition_to_next_state("AttackMove", {"AttackMoveTargetPosition" : rally_point.global_position})
			
		if spawn_point:
			produced_unit.position = spawn_point.global_position
		else:
			produced_unit.position = owner.global_position
			print(owner.name + " does not have a spawn point assigned. Spawning at " + str(produced_unit.position) + " instead.")
		#print(owner.name + " produced a " + producing_unit_node.name + " at " + str(owner.global_position))

		production_node_list.erase(producing_unit_node)
		if production_behaviour != ProductionBehaviour.USER:
			refresh_unit_list()
		if production_node_list.size() > 0:
			producing_unit_node = production_node_list.front()
		current_production_progress = 0.0

func pay_for_production(type,amount) -> void:
	var remove_resource = ChangeResourceAmount.new(resources_inventory,type, -amount)
	remove_resource.execute()

func has_enough_resources(type,amount) -> bool:
	var current_amount = resources_inventory.game_resources_dictionary.get(type)
	if current_amount >= amount:
		return true
	else:
		return false
	
func change_rally_point(rally_point,location):
	rally_point.global_position = location
