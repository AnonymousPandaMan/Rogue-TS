class_name ProduceButton
extends ControlGridButton

@export var produced_unit : ProducedUnit # Which unit from the production component you want to produce when this button is pressed. A production component is required and must be set to "USER" behaviour.

signal production_button_pressed(produced_unit)

func _ready():
	pass

func _pressed():
	production_button_pressed.emit(produced_unit)
