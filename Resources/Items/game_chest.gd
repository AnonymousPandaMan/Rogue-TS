extends Node2D


@export var item_list : GameItemList
@export_range(0,5) var item_selections := 0 ##Amount of Item selections available in the menu.

@onready var popup_menu = $PopupMenu

var chest_items = []

func _ready():
	## Gets 3 items from the item list and populates the popup menu.
	var list_size = item_list.item_list.size()
	while chest_items.size() < item_selections:
		var picked_item : Item = item_list.item_list.pick_random()
		var rng = randf_range(0,1)
		match picked_item.item_rarity:
			picked_item.rarity.COMMON:
				if rng < 0.4:
					chest_items.append(picked_item)
			picked_item.rarity.RARE:
				if rng < 0.15:
					chest_items.append(picked_item)
			picked_item.rarity.LEGENDARY:
				if rng < 0.05:
					chest_items.append(picked_item)
	
	for item : Item in chest_items:
		popup_menu.add_icon_item(item.sprite,item.item_name,chest_items.find(item))
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		popup_menu.visible = true
		popup_menu.position = get_global_transform_with_canvas().get_origin()
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	var overlapping_bodies = $Area2D.get_overlapping_bodies()
	for unit in overlapping_bodies:
		if unit.is_in_group("Player"):
			return
	popup_menu.visible = false
	pass # Replace with function body.


func _on_popup_menu_id_pressed(id):
	var selected_item = chest_items[id]
	GameInventory.add_item(selected_item, "Player")
	queue_free()
	pass # Replace with function body.
