class_name BuildHologram
extends Sprite2D

var construction_scene
var construction_offset : Vector2
var assigned_units : Array = []

func _init(hologram : Texture2D, construction , construction_offset):
	texture = hologram
	modulate = Color(0.5,1,0.5,0.5)
	self.construction_scene = construction
	self.construction_offset = construction_offset
	
func _process(delta):
	if assigned_units.size() <= 0:
		queue_free()
	pass

func _on_construction_start():
	var construction = construction_scene.instantiate()
	get_tree().get_first_node_in_group("Level").add_child(construction)
	construction.global_position = global_position - construction_offset
	for unit in assigned_units:
		unit.state_machine._transition_to_next_state("Building", {"BuildTarget" : construction})
	queue_free()
	
