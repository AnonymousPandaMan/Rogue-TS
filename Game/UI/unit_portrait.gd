class_name UnitPortrait
extends Control

@onready var background : ColorRect = $Background 
@onready var sprite = $Sprite

func _ready():
	sprite.material = ShaderMaterial.new()
	sprite.material.shader = load("res://Resources/Shaders/outline.gdshader")
	sprite.material.set("shader_parameter/width", 3)
	set_shader_colour(Color.GREEN)

func _on_unit_health_percentage_changed(percentage):
	if percentage > 80:
		background.color = Color.GREEN
		set_shader_colour(Color.GREEN)
	elif percentage <= 20:
		background.color = Color.RED
		set_shader_colour(Color.RED)
	elif percentage<= 40:
		background.color = Color.ORANGE_RED
		set_shader_colour(Color.ORANGE_RED)
	elif percentage <= 60:
		background.color = Color.ORANGE
		set_shader_colour(Color.ORANGE)
	elif percentage <= 80:
		background.color = Color.YELLOW
		set_shader_colour(Color.YELLOW)
	pass

func set_shader_colour(color : Color):
	sprite.material.set("shader_parameter/color", color)
