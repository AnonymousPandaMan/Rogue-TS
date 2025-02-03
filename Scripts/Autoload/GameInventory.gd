extends Node

signal item_dictionary_changed(inventory)

var game_item_dictionary : Dictionary = {}

var game_unlocked_units : Array = []

var game_resources_dictionary : Dictionary = {
	"Wood" : 200,
	"Meat" : 200,
	"Gold" : 200
}

func add_resources(type : String, amount : int):
	var game_resource_amount : int = game_resources_dictionary.get_or_add(type)
	game_resource_amount += amount
	game_resources_dictionary.merge({type:game_resource_amount}, true)
	
func has_enough_resources(type : String, amount: int) -> bool:
	var current_amount = game_resources_dictionary.get(type)
	if current_amount >= amount:
		return true
	else:
		return false
		
func change_resource_amount(type : String, amount: int) -> void:
	var game_resource_amount : int = game_resources_dictionary.get_or_add(type)
	game_resource_amount += amount
	game_resources_dictionary.merge({type:game_resource_amount}, true)

func add_item(item: Item, allegiance : String):
	if game_item_dictionary.has(item):
		var stack_size = game_item_dictionary.get(item)
		game_item_dictionary.erase(item)
		game_item_dictionary.get_or_add(item, stack_size + 1)
	else:
		game_item_dictionary.get_or_add(item , 1)
	var affected_units = get_tree().get_nodes_in_group(allegiance)
	for unit in affected_units:
		apply_item_modifications(unit, item)
	
	item_dictionary_changed.emit(game_item_dictionary)
	
func get_item_dict(allegiance):
	print(str(game_item_dictionary))
	return game_item_dictionary

func apply_all_current_items_modifications(unit : Unit):
	#applies all current items to a unit. Only use on freshly spawned units.
	if unit.unit_stats.allegiance == "Player":
		for key in game_item_dictionary.keys():
			var stack_size = game_item_dictionary.get(key)
			for i in stack_size:
				apply_item_modifications(unit, key)

func apply_item_modifications(unit : Unit, item : Item):
	if item is StatItem:
		item.apply_all_properties(unit)
