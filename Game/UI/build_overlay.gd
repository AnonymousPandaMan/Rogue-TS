class_name BuildOverlay
extends Area2D

signal confirmed_placement_location(placement_location)

var top_left_sprite = preload("res://Assets/Tiny Swords (Update 010)/UI/Pointers/03.png")
var top_right_sprite = preload("res://Assets/Tiny Swords (Update 010)/UI/Pointers/04.png")
var bottom_left_sprite = preload("res://Assets/Tiny Swords (Update 010)/UI/Pointers/05.png")
var bottom_right_sprite = preload("res://Assets/Tiny Swords (Update 010)/UI/Pointers/06.png")

var built_unit_node : BuiltUnit
var footprint_x : int
var footprint_y : int
var sprite_offset := Vector2(0,0)

var tile_size :int = 64
var bounding_box_size : Vector2 = Vector2i.ZERO
var bounding_box : CollisionShape2D
var bounding_box_offset := Vector2.ZERO

var clearance := true

func start_selection(built_unit):
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
	built_unit_node = built_unit
	# hologram preview
	if built_unit.preview_sprite:
		$Sprite.texture = built_unit.preview_sprite
		$Sprite.modulate = Color(0.5,1,0.5,0.5)
		$Sprite.offset = sprite_offset
	self.footprint_x = built_unit.unit_stats.footprint_x
	self.footprint_y = built_unit.unit_stats.footprint_y
	self.sprite_offset = built_unit.preview_sprite_offset
	
	
	calculate_bounding_box()

func _process(delta):
	move_hologram()

func _physics_process(delta):
	var overlapping_bodies = get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
		clearance = false
		$Sprite.modulate = Color(1,0.5,0.5,0.5)
	else:
		clearance = true
		$Sprite.modulate = Color(0.5,1,0.5,0.5)

func _input(event):
	if Input.is_action_just_released("select"):
		if clearance == true:
			confirmed_placement_location.emit(global_position)
			stop_selection()
		else:
			print("No clearance while trying to build")
	if Input.is_action_just_pressed("cancel"):
		stop_selection()

func calculate_bounding_box():
	bounding_box = $Collision
	bounding_box_size = Vector2(footprint_x * tile_size - 20, footprint_y * tile_size - 20)
	bounding_box.shape.set_size(bounding_box_size)
	bounding_box.position -= sprite_offset
	

func move_hologram():
	var mouse_position = get_global_mouse_position()
	var hologram_position := global_position
	hologram_position.x = snapped(mouse_position.x, 64)
	if is_odd(footprint_x):
		hologram_position.x += tile_size/2
	hologram_position.y = snapped(mouse_position.y, 64)
	if is_odd(footprint_y):
		hologram_position.y += tile_size/2
	
	global_position = hologram_position
	
func stop_selection():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	queue_free()


func is_odd(x: int):
	return x % 2 != 0
