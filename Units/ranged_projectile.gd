class_name RangedProjectile
extends Sprite2D

signal reached_target(unit)

var projectile_speed : float = 1000
var sprite : Texture2D
var projectile_owner : Unit
var target : Unit
var damage : float

func _init(projectile_owner, target, projectile_speed, size_modifier, sprite):
	if is_instance_valid(target):
		self.projectile_owner = projectile_owner
		self.target = target
		self.projectile_speed = projectile_speed
		
		texture = sprite
		global_position = projectile_owner.global_position
		scale.x = size_modifier
		scale.y = size_modifier
		
		z_index = 2
		

func _physics_process(delta):
	if is_instance_valid(target):
		if global_position.distance_to(target.global_position) > 20:
			var normalised_rotation = position.direction_to(target.position)
			position += normalised_rotation * projectile_speed * delta
			projectile_speed *= 0.975
			rotation = normalised_rotation.angle()
			if projectile_speed <= 300:
				queue_free()
		else:
			reached_target.emit(target)
			queue_free()
	else:
		queue_free()
