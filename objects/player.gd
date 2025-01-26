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
var breathingin = false
var player_bubble #the player's bubble they need to look after, directly accessible here

@export var player_number = 1
@onready var left_input = "p%s_left" % player_number
@onready var right_input = "p%s_right" % player_number
@onready var jump_input = "p%s_jump" % player_number
@onready var blow_input = "p%s_blow" % player_number

var state = states.FLOAT:
	set(value):
		state = value
		animation.animation = "idle"
enum states {JUMP, UNDERWATER, FLOAT, DESCEND, BLOWRECOIL}

func _ready() -> void:
	animation.play("idle")
	modulate = Global.player_colors[player_number-1]


func _physics_process(delta: float) -> void:
	if player_bubble == null:
		player_bubble = load("res://objects/playerbubble.tscn").instantiate()
		#player_bubble.global_position = global_position
		player_bubble.get_node("AnimatedSprite2D/Sprite2D").modulate = modulate
		get_parent().add_child(player_bubble)
		player_bubble.position = position + Vector2(0, -300)
		print(player_bubble.position)
		player_bubble.show()
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
					if velocity.y < 150:
						state = states.UNDERWATER # stop at the surface
					else:
						state = states.BLOWRECOIL # continue bouncing
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
		states.BLOWRECOIL:
			velocity.y -= BUOYANCY * delta
			if velocity.y <= 0:
				state = states.JUMP
				velocity.y = 0
			
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
	position.x = clampf(position.x, -Global.wall_limit, Global.wall_limit)
	#$Label.text = states.keys()[state]

func check_descend():
	#call this to give the player the option to descend
	if Input.is_action_pressed(jump_input):
		state = states.DESCEND

func handle_animations():
	if breathingin:
		if force == 1:
			animation.play("full")
		else:
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
		if state == states.BLOWRECOIL:
			animation.play("spin")
			if animation.flip_h:
				animation.speed_scale = -1
			else:
				animation.speed_scale = 1
		

func handle_blowing(delta):
	#$BlowArea.rotation = deg_to_rad(90) + get_angle_to(get_global_mouse_position())
	if Input.is_action_pressed(blow_input) and breath_cooldown.is_stopped():
		if breathingin:
			force = min(1, force+delta*2)
			if animation.scale < Vector2.ONE*1.25:
				animation.scale += Vector2.ONE*delta*0.5
		else:
			force = 0
			breathingin = true

	if Input.is_action_just_released(blow_input) and breathingin:
		animation.scale = Vector2.ONE
		#print(force)
		var blowparticle = preload("res://objects/blowparticle.tscn").instantiate()
		blowparticle.global_position = global_position
		blowparticle.initial_velocity_min = force * 400
		blowparticle.initial_velocity_max = force * 600
		blowparticle.linear_accel_max = force * -450
		blowparticle.emitting = true
		blowparticle.position.y -= 10
		get_parent().add_child(blowparticle)
		blow_hbox.set_deferred("disabled", false)
		
		if state == states.FLOAT:
			velocity.y += force * 300
			state = states.BLOWRECOIL
		if state==states.JUMP:
			velocity.y += force * 100
		
			
		breathingin = false
		breath_cooldown.start()
		animation.play("blow")

func _on_blow_area_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("bubble"):
		body.apply_impulse(force*Vector2(2*(body.position.x-position.x),(-50000/max(80, abs(body.position.y-position.y)))))




func _on_animation_finished() -> void:
	match animation.animation:
		"turn", "blow":
			animation.play("idle")


func _on_breath_cooldown_timeout() -> void:
	blow_hbox.set_deferred("disabled", true)
