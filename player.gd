extends CharacterBody2D

@onready var blow_hbox = $BlowArea/CollisionShape2D

const MAX_SPEED = 300.0
const GROUND_ACCEL = 1500.0
const GROUND_DECEL = 2000.0
const AIR_ACCEL = 800.0
const AIR_DECEL = 400.0
const JUMP_VELOCITY = -400.0

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
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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
	
	$Label.text = str(breath) + "%"

	move_and_slide()
