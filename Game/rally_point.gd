class_name RallyPoint
extends Node2D

## for creating a new rally point. Currently unimplemented.
func _init(producer: ProducerComponent , location : Vector2):
	producer.rally_point = self
	self.global_position = location
	print(str(global_position))
	var sprite = Sprite2D.new()
	sprite.texture = load("res://Game/UI/rally_point.tres")
	sprite.add_child(self)
