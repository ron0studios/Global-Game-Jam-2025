extends CharacterBody2D

@onready var blow_hbox = $BlowArea/CollisionShape2D

const ACCEL = 1000
const DECEL = 300
const MAX_SPD = 200
const GRAV = 1000
const BUOYANCY = 1500
var fall_factor = 1
var force

var state = states.ONLEVEL
enum states {OVERWATER, UNDERWATER, ONLEVEL, TURNAROUND}

var breath = 100
var blowing = false: #enables blowing hitbox when true
	set(value):
		if blowing != value:
			blow_hbox.set_deferred("disabled", !value)
		blowing = value



func _physics_process(delta: float) -> void:
	match state:
		states.ONLEVEL:
			position.y = Global.water_level
			velocity.y = 0
			var direction := Input.get_axis("ui_left", "ui_right")
			if direction:
				velocity.x = clamp(velocity.x + direction * ACCEL * delta, -MAX_SPD, MAX_SPD)
			else:
				if velocity.x > 0:
					velocity.x = max(0, velocity.x - DECEL*delta)
				if velocity.x < 0:
					velocity.x = min(0, velocity.x + DECEL*delta)
			if Input.is_action_just_pressed("jump"):
				state = states.OVERWATER
				velocity.y = -400
				position.y -= 10
		states.OVERWATER:
			print("HUH")
			if -50 < velocity.y and velocity.y < 50:
				velocity.y += GRAV/2 * delta
			else:
				velocity.y += GRAV * delta
			if position.y > Global.water_level:
				state = states.UNDERWATER
		states.UNDERWATER:
			velocity.y -= BUOYANCY * delta
			if position.y + velocity.y*delta < Global.water_level:
				state = states.ONLEVEL
				position.y = Global.water_level
				velocity.y = 0
	
	
	handle_blowing(delta)

	move_and_slide()
	$Label.text = states.keys()[state]



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
