extends CanvasLayer

@onready var resource_label = $ResourcesLabel

func update_resource_labels(text) -> void:
	resource_label.text = text
