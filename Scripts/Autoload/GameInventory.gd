extends Node

var game_item_dictionary : Dictionary

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
