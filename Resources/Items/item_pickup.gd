class_name ItemPickup
extends Node2D

@export var item : Item
@export var adds_item : bool

@export var adds_meat: int
@export var adds_gold: int

@export var size_multiplier : int = 1

@export_group("Assigns")
@export var item_sprite: Sprite2D
@export var pickup_area: Area2D



func _ready():
	var current_size = item.sprite.get_size()
	item_sprite.texture = item.sprite
	scale = Vector2(size_multiplier,size_multiplier)

func _on_pickup_area_body_entered(body):
	if body is Unit:
		if body.unit_stats.allegiance == "Player":
			if adds_item:
				GameInventory.add_item(item, "Player")
			if adds_meat > 0:
				var add_resources = ChangeResourceAmount.new(GameInventory, "Meat", adds_meat)
				add_resources.execute()
			if adds_gold > 0:
				var add_resources = ChangeResourceAmount.new(GameInventory, "Gold", adds_gold)
				add_resources.execute()
			queue_free()
