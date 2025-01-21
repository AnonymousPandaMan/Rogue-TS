class_name SelectorOverlay
extends Sprite2D

var sprite_texture = preload("res://Assets/Tiny Swords (Update 010)/UI/Pointers/01.png")
var selected_sprite_texture = preload("res://Assets/Tiny Swords (Update 010)/UI/Pointers/02.png")

var selector_range : int
var selector_target_group : String
var selected_object : Node
var currently_selecting : bool

signal object_selected(object)


func _init(target_group, range : int):
	if range > 0:
		self.selector_range = range
	selector_target_group = target_group

func _ready():
	texture = sprite_texture
	
func _physics_process(delta):
	currently_selecting = true
	var mouse_position = get_global_mouse_position()
	var target_group_nodes : Array = [] 
	target_group_nodes = get_tree().get_nodes_in_group(selector_target_group)
	if target_group_nodes.size() > 0:
		var closest_object = target_group_nodes[0]
		for node in target_group_nodes:
			if node.global_position.distance_squared_to(mouse_position) < closest_object.global_position.distance_squared_to(mouse_position):
				closest_object = node
		if closest_object.global_position.distance_squared_to(mouse_position) < 400:
			selected_object = closest_object
			global_position = closest_object.global_position
			texture = selected_sprite_texture
		else:
			texture = sprite_texture
			global_position = get_global_mouse_position()

func _input(event):
	if Input.is_action_pressed("select"):
		currently_selecting = true
		var mouse_position = get_global_mouse_position()
		var target_group_nodes : Array = [] 
		target_group_nodes = get_tree().get_nodes_in_group(selector_target_group)
		if target_group_nodes.size() > 0:
			var closest_object = target_group_nodes[0]
			for node in target_group_nodes:
				if node.global_position.distance_squared_to(mouse_position) < closest_object.global_position.distance_squared_to(mouse_position):
					closest_object = node
			if closest_object.global_position.distance_squared_to(mouse_position) < 400:
				selected_object = closest_object
				global_position = closest_object.global_position
	if Input.is_action_just_released("select"):
		currently_selecting = false
		if selected_object:
			object_selected.emit(selected_object)
			queue_free()
	
	if Input.is_action_just_pressed("cancel"):
		queue_free()
