class_name BuiltUnit
extends Node

@export_file("*.tscn") var construction_scene : String ##The construction-in-progress unit scene filepath
@export_file("*.tscn") var building_scene: String 

@export var unit_stats : UnitStats
@export var unit_costs : UnitCosts

@export var preview_sprite : Texture2D ##The preview sprite that is shown when selecting where to build
@export var preview_sprite_offset : Vector2 ##The preview's offset from the centre of the sprite (due to building scenes being innately offset from the centre)
