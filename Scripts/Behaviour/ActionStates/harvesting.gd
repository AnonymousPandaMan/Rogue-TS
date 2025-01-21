extends UnitState

var harvest_target : Harvestable
var currently_harvesting = false
var harvest_frequency : float
var current_harvest_progress : float

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	if is_instance_valid(harvest_target):
		if harvest_target.global_position.distance_to(unit.global_position) < unit.unit_stats.harvest_range:
			currently_harvesting = true
			var facing_direction = unit.global_position.direction_to(harvest_target.global_position)
			unit.unit_animation.set_blend_position("parameters/UnitState/Harvest/blend_position",facing_direction.x)
			unit.unit_animation.set_condition("parameters/UnitState/conditions/harvest", true)
			
	if currently_harvesting:
		current_harvest_progress += _delta
		if current_harvest_progress >= harvest_frequency:
			harvest_resources()
			current_harvest_progress = 0
		
	pass

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	if data:
		harvest_target = data.get("HarvestTarget")
		harvest_frequency = unit.unit_stats.harvest_speed / unit.unit_stats.harvest_animation_time
	pass

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	unit.unit_animation.set_condition("parameters/UnitState/conditions/harvest", false)
	currently_harvesting = false
	pass

func harvest_resources():
	var harvest_amount = unit.unit_stats.harvest_power * harvest_target.harvesting_multiplier
	GameInventory.add_resources(harvest_target.resource_harvested,harvest_amount)
	harvest_target.call("_on_harvested", harvest_amount)
