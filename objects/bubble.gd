extends RigidBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var health = 50:
	set(value):
		health = value
		#scale = Vector2.ONE * (0.5+(health/100))



var underwater = false

func _ready() -> void:
	animated_sprite_2d.play("default")
	health = health

	
#func hit_floor():
	#var wobble = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
	##$Sprite2D.scale = Vector2(1.2,1.2)
	#$CPUParticles2D.emitting = true
	#hit.emit()


	

func _physics_process(delta: float) -> void:
	if health < 0:
		var deadbubble = preload("res://objects/deadbubble.tscn").instantiate()
		deadbubble.position = position
		deadbubble.play("default")
		get_parent().add_child(deadbubble)
		queue_free()
	if position.y > Global.water_level:
		underwater = true
		linear_velocity *= 0.7
		health -= delta * 10
		apply_impulse(Vector2.UP * (position.y-Global.water_level) * 0.2)
	else:
		underwater = false
	linear_velocity.x = clamp(linear_velocity.x,-1000,1000)
	linear_velocity.y = clamp(linear_velocity.y, -1000,1000)
	$Label.text = str(health, scale, animated_sprite_2d.scale)
	rotation = 0
	
	#print(animated_sprite_2d.material.shader)


#func _on_body_entered(body: Node) -> void:
	#
	#if body.name == "StaticBody2D":
		#hit_floor()


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player") and body.position.y > position.y+20:
		health -= 30
		if health <= 0:
			body.player_bubble.position
		linear_velocity.y = min(-300, linear_velocity.y)
		
