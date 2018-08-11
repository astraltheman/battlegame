extends KinematicBody2D

const SPEED = 1200
const velocity = Vector2(1, 0)

func start(pos, dir):
	rotation = dir
	position = pos

func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized().rotated(rotation) * SPEED * delta)
	if collision_info:
		if collision_info.collider.has_method("player_hit"):
			collision_info.collider.player_hit()
		queue_free()

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
