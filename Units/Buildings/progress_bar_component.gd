extends ProgressBar

class_name ProgressBarComponent

func update_progress_bar(over, under):
	if over:
		if under:
			value = (over/under)*100
func _ready():
		position = owner.owner.global_position + position
