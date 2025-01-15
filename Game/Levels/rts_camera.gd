extends Camera2D

@export var threshold = 100
@export var step = 10
@onready var viewport_size = get_viewport().size

func _process(delta):
	viewport_size = get_viewport().size
	var local_mouse_pos = get_local_mouse_position()
	if local_mouse_pos.x < threshold:
		position.x -= step
	elif local_mouse_pos.x > viewport_size.x - threshold:
		position.x += step
	if local_mouse_pos.y < threshold:
		position.y -= step
	elif local_mouse_pos.y > viewport_size.y - threshold:
		position.y += step

func _input(event):
	if Input.is_action_pressed("scroll_up"):
		zoom = Vector2(zoom.x*0.95,zoom.y*0.95)
	if Input.is_action_pressed("scroll_down"):
		zoom = Vector2(zoom.x*1.05,zoom.y*1.05)
