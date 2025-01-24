extends CharacterBody2D

@onready var blow_hbox = $BlowArea/CollisionShape2D

const MAX_SPEED = 300.0
const GROUND_ACCEL = 1500000.0
const GROUND_DECEL = 2000000.0
const AIR_ACCEL = GROUND_ACCEL*0.7
const AIR_DECEL = GROUND_ACCEL*0.7
const JUMP_VELOCITY = -600.0
const FALL_MULTIPLIER = 1.5 # how much faster to fall when jump key released
var fall_factor = 1


var breath = 100
var blowing = false: #enables blowing hitbox when true
	set(value):
		if blowing != value:
			blow_hbox.set_deferred("disabled", !value)
		blowing = value



func _physics_process(delta: float) -> void:
	var accel = GROUND_ACCEL
	var decel = GROUND_DECEL
	
	# Add the gravity.
	if not is_on_floor():
		accel = AIR_ACCEL
		decel = AIR_DECEL
		velocity += get_gravity() * delta * fall_factor
	else:
		fall_factor = 1

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_released("jump") and not is_on_floor():
		fall_factor = FALL_MULTIPLIER
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = clamp(velocity.x + direction * accel * delta, -MAX_SPEED, MAX_SPEED)
	else:
		if velocity.x > 0:
			velocity.x = max(0, velocity.x - decel*delta)
		if velocity.x < 0:
			velocity.x = min(0, velocity.x + decel*delta)
	
	if Input.is_action_pressed("blow"): #Space key
		blowing = false
		breath = max(0, breath-delta*60)
	else:
		blowing = breath < 100
		breath = min(100, breath+delta*60)
	
	if Input.is_action_just_released("blow"):
		$BlowArea/blowparticle.emitting = true
	
	$Label.text = str(breath) + "%"

	move_and_slide()
