extends Node

var game_item_dictionary : Dictionary

var game_resources_dictionary : Dictionary = {
	"Wood" : 200,
	"Meat" : 200,
	"Gold" : 200
}

func add_resources(type,amount):
	var game_resource_amount : int = game_resources_dictionary.get_or_add(type)
	game_resource_amount += amount
	game_resources_dictionary.merge({type:game_resource_amount}, true)
	
