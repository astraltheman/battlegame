extends KinematicBody2D

export (int) var speed = 200

var bullet = preload("res://Bullet.tscn")
var velocity = Vector2()
var sliding = false
var bit_by_zombo = false
var active_speed = speed
var can_shoot = true

func get_input():
	look_at(get_global_mouse_position())
	
	velocity = Vector2()
	active_speed = speed
	
	if Input.is_action_pressed('back'):
		velocity.x -= 1
	if Input.is_action_pressed('forward'):
		velocity.x += 1
	if Input.is_action_just_pressed('left'):
		velocity = Vector2(0,-1)
		slide_setup()
	if Input.is_action_just_pressed('right'):
		velocity = Vector2(0,1)
		slide_setup()
	if Input.is_action_pressed('shoot') and can_shoot:
		shoot()
		
	velocity = velocity.normalized().rotated(rotation) * active_speed
		
func _physics_process(delta):
	if sliding == false and bit_by_zombo == false:
		get_input()
	move_and_slide(velocity)
	
	
func slide_setup():
	sliding = true
	$DodgeTrail.emitting = true
	$DodgeTrail.process_material.angle = -rotation_degrees
	active_speed = speed * 2
	$SlideTimer.start()

func shoot():
	can_shoot = false
	var b = bullet.instance()
	b.start(global_position, rotation)
	get_parent().add_child(b)
	$ShootTimer.start()

func bit_by_zombie():
	bit_by_zombo = true
	active_speed = speed * 2
	velocity = Vector2(-1, 0)
	velocity = velocity.normalized().rotated(rotation) * active_speed
	$BitTimer.start()

func _on_SlideTimer_timeout():
	sliding = false
	active_speed = speed
	$DodgeTrail.emitting = false

func _on_BitTimer_timeout():
	bit_by_zombo = false
	active_speed = speed

func _on_ShootTimer_timeout():
	can_shoot = true
