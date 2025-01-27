class_name CommandButton
extends ControlGridButton

signal command_button_pressed(commanded_state, target) # requires the command buttong to be pressed and to have a valid selection

@export var commanded_state : String ## String of the commanded states name
@export var commanded_unit : Unit

enum DEMAND_TARGET {TARGET_UNIT, TARGET_LOCATION, TARGET_HARVESTABLE, SELF, NONE}
@export var demand_target : DEMAND_TARGET
@export var target_group : String ## if demand_target = TARGET_UNIT, the group that is searched from

func _on_pressed():
	var target
	## currently getting mouse position as the target
	match demand_target:
		DEMAND_TARGET.TARGET_UNIT:
			var selector = SelectorOverlay.new("Construction", 0)
			selector.object_selected.connect(_on_object_selected)
			commanded_unit.get_tree().get_first_node_in_group("Level").add_child(selector)
		DEMAND_TARGET.TARGET_LOCATION:
			target = get_global_mouse_position()
		DEMAND_TARGET.TARGET_HARVESTABLE:
			var selector = SelectorOverlay.new("Harvestable", 0)
			selector.object_selected.connect(_on_object_selected)
			commanded_unit.get_tree().get_first_node_in_group("Level").add_child(selector)
			
			return
		DEMAND_TARGET.SELF:
			target = commanded_unit # probably doesnt work
		DEMAND_TARGET.NONE:
			target = null
	command_button_pressed.emit(commanded_state, target)
	pass

func _on_object_selected(object): # called when an object is selected by the selector
	command_button_pressed.emit(commanded_state, object)
	print(object.name)
	
