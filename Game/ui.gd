extends CanvasLayer

@onready var resource_label = %ResourcesLabel
@onready var item_inventory = %ItemInventory

var inventory_item = preload("res://Resources/Items/inventory_item.tscn")


func _ready():
	GameInventory.item_dictionary_changed.connect(_on_item_dictionary_changed)

func update_resource_labels(text) -> void:
	resource_label.text = text

func update_inventory():
	for child in item_inventory.get_children():
		child.queue_free()
	var current_inventory = GameInventory.get_item_dict("Player")
	for key in current_inventory.keys():
		var stack_size = current_inventory.get(key)
		add_item_to_inventory(key , stack_size)

func add_item_to_inventory(item, stack_size):
	var item_holder = inventory_item.instantiate()
	item_holder.set_item(item)
	if stack_size:
		item_holder.set_stack_size(stack_size)
	item_inventory.add_child(item_holder)

func _on_item_dictionary_changed(inventory): ## called when the game item inventory is changed
	update_inventory()
