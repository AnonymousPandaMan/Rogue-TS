class_name InventoryItem
extends TextureRect


var item : Item

@onready var popup_panel = %Panel
@onready var item_desciption = %Description

func _ready():
	popup_panel.visible = false
	
func set_item(_item):
	self.item = _item
	texture = item.sprite
	
	# item description and flavour
	await self.ready
	var formatted_description = format_text(item.formatted_description())
	var formatted_title = "[b]" + item.item_name + "[/b]: "
	item_desciption.text = formatted_title + formatted_description + item.formatted_flavour()
	
	popup_panel.size = item_desciption.size
	popup_panel.size.y = item_desciption.get_minimum_size().y
	
func set_stack_size(stack_size: int):
	if stack_size <= 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = str(stack_size)

func format_text(_text) -> String: # replaces parts of the string with BBcode tooltips for more colourful and contextual text
	var formatted_text = _text
	formatted_text = formatted_text.replacen("[base]", "[b][color=yellow]base[/color][/b]")
	formatted_text = formatted_text.replacen("[attack_damage]", "[b][color=red]attack damage[/color][/b]")
	formatted_text = formatted_text.replacen("[attack_speed]","[b][color=red]attack speed[/color][/b]")
	return formatted_text
	pass

func _on_mouse_entered():
	popup_panel.visible = true
	pass # Replace with function body.


func _on_mouse_exited():
	popup_panel.visible = false
	pass # Replace with function body.
