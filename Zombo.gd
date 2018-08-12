extends KinematicBody2D

var active_on_screen = false
export (int) var hits = 1
export (int) var speed = 100
const VELOCITY = Vector2(1, 0)
var target
var can_bite = true

var follow = preload("res://assets/PNG/Zombie 1/zoimbie1_hold.png")
var stand = preload("res://assets/PNG/Zombie 1/zoimbie1_stand.png")

func player_hit():
	hits -= 1
	if hits <= 0:
		queue_free()

func _on_VisibilityNotifier2D_viewport_entered(viewport):
	target = get_parent().get_node("Player")
	active_on_screen = true
	
func _physics_process(delta):
	if active_on_screen:
		look_at(target.global_position)
		if can_bite:
			move_and_slide(VELOCITY.normalized().rotated(rotation) * speed)
			check_for_bite()

func _on_BiteTimer_timeout():
	can_bite = true
	$Sprite.texture = follow

func check_for_bite():
	var slide_count = get_slide_count()
	if slide_count > 0:
		for i in range(slide_count):
			var collision_info = get_slide_collision(i)
			if collision_info.collider.has_method("bit_by_zombie") and can_bite:
				can_bite = false
				collision_info.collider.bit_by_zombie()
				$Sprite.texture = stand
				$BiteTimer.start()

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	active_on_screen = false
