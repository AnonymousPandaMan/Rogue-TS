class_name UnitPortrait
extends Control

@onready var background : ColorRect = $Background 

func _on_unit_health_percentage_changed(percentage):
	if percentage > 70:
		background.color = Color.GREEN
	elif percentage <= 30:
		background.color = Color.RED
	elif percentage <= 70:
		background.color = Color.ORANGE
	pass
