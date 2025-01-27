class_name BuildOverlay
extends Sprite2D

signal confirmed_placement_location(placement_location)

var top_left_sprite = preload("res://Assets/Tiny Swords (Update 010)/UI/Pointers/03.png")
var top_right_sprite = preload("res://Assets/Tiny Swords (Update 010)/UI/Pointers/04.png")
var bottom_left_sprite = preload("res://Assets/Tiny Swords (Update 010)/UI/Pointers/05.png")
var bottom_right_sprite = preload("res://Assets/Tiny Swords (Update 010)/UI/Pointers/06.png")

var built_unit_node : BuiltUnit
var footprint_x : int
var footprint_y : int
var sprite_offset = Vector2(0,0)

func _init(built_unit : BuiltUnit):
	built_unit_node = built_unit
	# hologram preview
	if built_unit.preview_sprite:
		texture = built_unit.preview_sprite
		modulate = Color(0.5,1,0.5,0.5)
	self.footprint_x = built_unit.unit_stats.footprint_x
	self.footprint_y = built_unit.unit_stats.footprint_y
	self.sprite_offset = built_unit.preview_sprite_offset
	pass

func _physics_process(delta):
	global_position = get_global_mouse_position() + sprite_offset
	pass

func _input(event):
	if Input.is_action_just_released("select"):
		confirmed_placement_location.emit(global_position)
		queue_free()
	if Input.is_action_just_pressed("cancel"):
		queue_free()
