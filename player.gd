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
var force

var state = states.ONLEVEL
enum states {OVERWATER, UNDERWATER, ONLEVEL}

var breath = 100
var blowing = false: #enables blowing hitbox when true
	set(value):
		if blowing != value:
			blow_hbox.set_deferred("disabled", !value)
		blowing = value



func _physics_process(delta: float) -> void:
	match state:
		states.ONLEVEL:
			pass
		states.OVERWATER:
			pass
		states.UNDERWATER:
			pass
	
	
	handle_blowing(delta)

	move_and_slide()



func handle_blowing(delta):
	if Input.is_action_just_pressed("blow"):
		blowing = true
		$Breathtimer.start()
		
	if Input.is_action_just_released("blow"):
		blowing = false
		$BlowArea/blowparticle.emitting = true
		force = ($Breathtimer.wait_time-$Breathtimer.time_left)/$Breathtimer.wait_time

	if Input.is_action_pressed("blow"): #Space key
		blowing = false
		breath = max(0, breath-delta*60)
	else:
		blowing = breath < 100
		breath = min(100, breath+delta*60)
	
	if Input.is_action_just_released("blow"):
		$BlowArea/blowparticle.emitting = true
	
	$Label.text = str(breath) + "%"

func _on_blow_area_body_entered(body: RigidBody2D) -> void:
	if body.name == "bubble":
		body.apply_impulse(Vector2.UP*1000*force)
	pass # Replace with function body. 
