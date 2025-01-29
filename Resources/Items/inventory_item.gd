class_name InventoryItem
extends TextureRect

var item : Item

func set_item(_item):
	self.item = _item
	texture = item.sprite
	
func set_stack_size(stack_size: int):
	if stack_size <= 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = str(stack_size)
