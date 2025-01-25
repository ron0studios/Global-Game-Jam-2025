extends CharacterBody2D

@onready var blow_hbox = $BlowArea/CollisionShape2D

const ACCEL = 1000
const DECEL = 300
const MAX_SPD = 200
const GRAV = 1000
const BUOYANCY = 1500
const SHOOTUP_BUOYANCY = 2000
const DEPTH = 150
var fall_factor = 1
var force

var state = states.FLOAT
enum states {JUMP, UNDERWATER, FLOAT, TURNAROUND, DESCEND}

var breath = 100
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
			if Input.is_action_just_released("ui_down"):
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
	var direction := Input.get_axis("ui_left", "ui_right")
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
	$Label.text = states.keys()[state]

func check_descend():
	#call this to give the player the option to descend
	if Input.is_action_just_pressed("ui_down"):
		state = states.DESCEND
func handle_animations():
	if (Input.is_action_just_pressed("left") and !$AnimatedSprite2D.flip_h) or (Input.is_action_just_pressed("right") and $AnimatedSprite2D.flip_h):
		$AnimatedSprite2D.play("turn")
	
	if $AnimatedSprite2D.animation == "turn" and $AnimatedSprite2D.frame == 5:
		$AnimatedSprite2D.play("idle")
		$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h

func handle_blowing(delta):
	$BlowArea.rotation = deg_to_rad(90) + get_angle_to(get_global_mouse_position())
	if Input.is_action_just_pressed("blow"):
		blowing = true
		$Breathtimer.start()
		
	if Input.is_action_just_released("blow"):
		print(global_position.direction_to($BlowArea/CollisionShape2D.global_position).normalized())
		var blowparticle = preload("res://objects/blowparticle.tscn").instantiate()
		blowparticle.rotation = $BlowArea.rotation
		get_parent().add_child(blowparticle)
		blowparticle.global_position = global_position
		blowparticle.emitting = true
		
		blowing = false
		force = ($Breathtimer.wait_time-$Breathtimer.time_left)/$Breathtimer.wait_time

	if Input.is_action_pressed("blow"): #Space key
		blowing = false
		breath = max(0, breath-delta*60)
	else:
		blowing = breath < 100
		breath = min(100, breath+delta*60)
	
	
	$Label.text = str(breath) + "%"

func _on_blow_area_body_entered(body: RigidBody2D) -> void:
	if body.name == "bubble":
		print("this worked")
		body.apply_impulse(global_position.direction_to($BlowArea/CollisionShape2D.global_position).normalized()*1000*force)
	pass # Replace with function body. 
