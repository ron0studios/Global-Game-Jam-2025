extends RigidBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var smack = preload("res://objects/smack.tscn")

@export var health = 50:
	set(value):
		health = value
		



var underwater = false

func _ready() -> void:
	animated_sprite_2d.play("default")
	health = health




	

func _physics_process(delta: float) -> void:
	if health <= 0:
		var deadbubble = preload("res://objects/deadbubble.tscn").instantiate()
		deadbubble.position = position
		deadbubble.play("default")
		get_parent().add_child(deadbubble)
		queue_free()
	if position.y > Global.water_level:
		$AnimatedSprite2D.speed_scale = 5
		if !underwater:
			underwater = true
			linear_velocity *= 0.7
		if health < 45:
			health = 0
		health -= delta * 10
		apply_impulse(Vector2.UP * (position.y-Global.water_level) * 0.1)
	else:
		$AnimatedSprite2D.speed_scale =1 
		underwater = false
	$Label.text = str(health, scale, animated_sprite_2d.scale)
	rotation = 0
	linear_velocity.clampf(-200, 200)
	#print(animated_sprite_2d.material.shader)

#func _on_body_entered(body: Node) -> void:
	#
	#if body.name == "StaticBody2D":
		#hit_floor()


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body.is_in_group("player") and body.velocity.y < 0:
		health -= 10
		var smack_inst = smack.instantiate()
		smack_inst.position = position + Vector2(0, 20*scale.y)
		get_parent().add_child(smack_inst)
		if health <= 0:
			var spark = preload("res://objects/spark.tscn").instantiate()
			get_parent().add_child(spark)
			spark.start_pos = position
			spark.modulate = body.modulate
			
			spark.set_target(body.player_bubble)
		linear_velocity.y = min(-300, linear_velocity.y)
		
