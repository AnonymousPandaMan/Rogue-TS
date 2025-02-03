class_name Item
extends Resource

@export var item_name : String = ""
@export var sprite : Texture2D = AtlasTexture.new()
@export_multiline var item_description : String = "This is an item description. Replace me with an item description. BBCode enabled"
@export_multiline var item_flavour : String = "This is an item flavour. Replace me with the item's flavour text. Automatic italics and BBCode enabled"

# override as needed in other items that inherit from this class
func formatted_description() -> String:
	return item_description
	pass

func formatted_flavour() -> String :
	var formatted_flavour = str("[p][i]" + item_flavour + "[/i][/p]")
	return formatted_flavour
