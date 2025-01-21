extends AnimatedSprite2D

func _ready():
	$Particles.emitting = true
	await get_tree().create_timer(0.3).timeout
	$Particles.emitting = false

func _on_animation_finished():
	queue_free()
