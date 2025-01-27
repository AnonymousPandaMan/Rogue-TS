extends ProgressBar

class_name ProgressBarComponent
@export var unit : Unit

var offset_position

func update_progress_bar(over, under):
	if over:
		if under:
			value = (over/under)*100

func _ready():
	offset_position = position
	
