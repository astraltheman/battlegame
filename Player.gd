extends KinematicBody2D

export (int) var speed = 200

var bullet = preload("res://Bullet.tscn")
var velocity = Vector2()
var sliding = false
var slidingFrames = 0

func get_input():
	look_at(get_global_mouse_position())
	
	velocity = Vector2()
	if Input.is_action_pressed('back'):
		velocity.x -= 1
	if Input.is_action_pressed('forward'):
		velocity.x += 1
	if Input.is_action_just_pressed('left'):
		$DodgeTrail.emitting = true
		$DodgeTrail.process_material.angle = -rotation_degrees
		sliding = true
		slidingFrames = 20
		velocity = Vector2(0,-1)
	if Input.is_action_just_pressed('right'):
		$DodgeTrail.emitting = true
		$DodgeTrail.process_material.angle = -rotation_degrees
		sliding = true
		slidingFrames = 20
		velocity = Vector2(0,1)
		
	var activeSpeed = 0
	if sliding == true:
		activeSpeed = speed * 2
	else:
		activeSpeed = speed
		
	velocity = velocity.normalized().rotated(rotation) * activeSpeed
		
func _physics_process(delta):
	if sliding == false:
		get_input()
	else:
		slidingFrames -= 1
		if slidingFrames == 0:
			sliding = false
			$DodgeTrail.emitting = false
	move_and_slide(velocity)
	
	if Input.is_action_just_released('shoot'):
		var b = bullet.instance()
		b.start(global_position, rotation)
		get_parent().add_child(b)
		