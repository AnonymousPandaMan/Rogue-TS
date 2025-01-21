extends UnitState

var harvest_target : Harvestable

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	if is_instance_valid(harvest_target):
		unit.unit_animation.set_condition("parameters/UnitState/conditions/harvest", true)
		var harvest_amount = unit.unit_stats.harvest_power * harvest_target.harvesting_multiplier
		GameInventory.add_resources(harvest_target.resource_harvested,harvest_amount)
		harvest_target.call("_on_harvested", harvest_amount)
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	pass

## Called by the state machine upon changing the active state. The `data` parameter
## is a dictionary with arbitrary data the state can use to initialize itself.
func enter(previous_state_path: String, data := {}) -> void:
	if data:
		harvest_target = data.get("HarvestTarget")
	pass

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	unit.unit_animation.set_condition("parameters/UnitState/conditions/harvest", false)
	pass
