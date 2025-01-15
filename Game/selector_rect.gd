extends Node2D

var rect_start = Vector2.ZERO
var rect_end = Vector2.ZERO
var drawing = false
var select_rect : Rect2

func _draw():
	if drawing:
		draw_rect(select_rect, Color.WHITE, false)
	
func update_draw(selector_rect, is_drawing : bool):
	select_rect = selector_rect
	drawing = is_drawing
