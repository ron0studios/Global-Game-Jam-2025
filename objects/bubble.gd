extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var fall_speed = 150
var prev_velocity
signal hit


func hit_floor():
	var wobble = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
	#$Sprite2D.scale = Vector2(1.2,1.2)
	$CPUParticles2D.emitting = true
	wobble.tween_property($Sprite2D,"scale", Vector2(1.1,1.1), 0.1)
	wobble.tween_property($Sprite2D,"scale", Vector2(0.9,0.9), 0.1)
	wobble.tween_property($Sprite2D,"scale", Vector2(1.05,1.05), 0.1)
	wobble.tween_property($Sprite2D,"scale", Vector2(1,1), 0.2)
	wobble.tween_callback(func(): $Sprite2D.scale = Vector2(1,1))
	hit.emit()
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += fall_speed * delta
	else:
		print("hit")
		print(prev_velocity)
		hit_floor()
		velocity.y = -prev_velocity
		
	prev_velocity = velocity.y # velocity before landing on floor
	move_and_slide()
	
