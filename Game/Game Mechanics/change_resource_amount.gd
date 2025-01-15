extends Object

class_name ChangeResourceAmount

var added_to 
var type : String
var amount : int

func _init(inv_added_to, type : String, amount : float):
	self.added_to = inv_added_to
	self.type = type
	self.amount = amount
	
func execute():
	var game_resource_amount : int = added_to.game_resources_dictionary.get_or_add(type)
	game_resource_amount += amount
	added_to.game_resources_dictionary.merge({type:game_resource_amount}, true)
