class_name ItemPickup
extends Node2D

@export var item : Item


@export var adds_item : bool ## non-functional atm

@export var adds_meat: int
@export var adds_gold: int

@export var item_sprite: Sprite2D
@export var pickup_area: Area2D

func _ready():
	item_sprite.texture = item.sprite

func _on_pickup_area_body_entered(body):
	if body is Unit:
		if body.unit_stats.allegiance == "Player":
			if adds_meat > 0:
				var add_resources = ChangeResourceAmount.new(GameInventory, "Meat", adds_meat)
				add_resources.execute()
			if adds_gold > 0:
				var add_resources = ChangeResourceAmount.new(GameInventory, "Gold", adds_gold)
				add_resources.execute()
			queue_free()
