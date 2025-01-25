extends CharacterBody2D

@onready var blow_hbox = $BlowArea/CollisionShape2D
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var breath_cooldown: Timer = $BreathCooldown

const ACCEL = 1000
const DECEL = 300
const MAX_SPD = 200
const GRAV = 1000
const BUOYANCY = 1500
const SHOOTUP_BUOYANCY = 2000
const DEPTH = 150

var force = 0

@export var player_number = 1
@onready var left_input = "p%s_left" % player_number
@onready var right_input = "p%s_right" % player_number
@onready var jump_input = "p%s_jump" % player_number
@onready var blow_input = "p%s_blow" % player_number

var state = states.FLOAT:
	set(value):
		state = value
		animation.animation = "idle"
enum states {JUMP, UNDERWATER, FLOAT, TURNAROUND, DESCEND}


var blowing = false: #enables blowing hitbox when true
	set(value):
		if blowing != value:
			blow_hbox.set_deferred("disabled", !value)
		blowing = value



func _physics_process(delta: float) -> void:
	match state:
		states.FLOAT:
			position.y = Global.water_level
			velocity.y = 0
			check_descend()
		states.DESCEND:
			velocity.y = (Global.water_level+DEPTH-position.y)
			if Input.is_action_just_released(jump_input):
				state = states.JUMP
				velocity.y = 0
		states.JUMP:
			if position.y > Global.water_level:
				if velocity.y > 0:
					velocity.y*=0.5
					state = states.UNDERWATER
				else:
					velocity.y -= SHOOTUP_BUOYANCY * delta
			else:
				if -50 < velocity.y and velocity.y < 50:
					velocity.y += GRAV/2 * delta
				else:
					velocity.y += GRAV * delta
		states.UNDERWATER:
			velocity.y -= BUOYANCY * delta
			if position.y + velocity.y*delta < Global.water_level:
				state = states.FLOAT
				position.y = Global.water_level
				velocity.y = 0
			check_descend()
	var direction := Input.get_axis(left_input, right_input)
	if direction:
		velocity.x = clamp(velocity.x + direction * ACCEL * delta, -MAX_SPD, MAX_SPD)
	else:
		if velocity.x > 0:
			velocity.x = max(0, velocity.x - DECEL*delta)
		if velocity.x < 0:
			velocity.x = min(0, velocity.x + DECEL*delta)
	
	handle_animations()
	handle_blowing(delta)

	move_and_slide()
	#$Label.text = states.keys()[state]

func check_descend():
	#call this to give the player the option to descend
	if Input.is_action_pressed(jump_input):
		state = states.DESCEND

func handle_animations():
	if !$Breathtimer.is_stopped():
		animation.play("breathe")
	else:
		if (Input.is_action_just_pressed(left_input) and !animation.flip_h) or (Input.is_action_just_pressed(right_input) and animation.flip_h):
			animation.flip_h = !animation.flip_h
			animation.play("turn")
		if position.y<Global.water_level:
			animation.play("spin")
			if animation.flip_h:
				animation.speed_scale = -1
			else:
				animation.speed_scale = 1
		
		
		

func handle_blowing(delta):
	#$BlowArea.rotation = deg_to_rad(90) + get_angle_to(get_global_mouse_position())
	if Input.is_action_pressed(blow_input) and breath_cooldown.is_stopped():
		blowing = true
		$Breathtimer.start()
		
	if Input.is_action_just_released(blow_input):
		#print(global_position.direction_to($BlowArea/CollisionShape2D.global_position).normalized())
		force = ($Breathtimer.wait_time-$Breathtimer.time_left)/$Breathtimer.wait_time
		print(force, "use the force luke")
		var blowparticle = preload("res://objects/blowparticle.tscn").instantiate()
		blowparticle.global_position = global_position
		blowparticle.initial_velocity_min = force * 400
		blowparticle.initial_velocity_max = force * 600
		blowparticle.linear_accel_max = force * -450
		blowparticle.emitting = true
		blowparticle.position.y -= 10
		get_parent().add_child(blowparticle)
		
		blowing = false
		$Breathtimer.stop()
		breath_cooldown.start()
		animation.play("blow")

func _on_blow_area_body_entered(body: RigidBody2D) -> void:
	if body.name == "bubble":
		print("this worked")
		body.apply_impulse(global_position.direction_to($BlowArea/CollisionShape2D.global_position).normalized()*1000*force)




func _on_animation_finished() -> void:
	match animation.animation:
		"turn", "blow":
			animation.play("idle")
