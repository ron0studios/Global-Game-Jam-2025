extends RigidBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var health = 50

# debug
var dead = false


signal hit

func _ready() -> void:
	animated_sprite_2d.play("default")

	
#func hit_floor():
	#var wobble = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
	##$Sprite2D.scale = Vector2(1.2,1.2)
	#$CPUParticles2D.emitting = true
	#hit.emit()

func die():
	var blowparticle = preload("res://objects/popparticle.tscn").instantiate()
	blowparticle.global_position = global_position
	blowparticle.emitting = true
	blowparticle.position.y -= 10
	get_parent().add_child(blowparticle)
	dead = true
	

func _physics_process(delta: float) -> void:
	if health < 0 and not dead:
		die()
	if position.y > Global.water_level:
		health -= delta * 10
		apply_impulse(Vector2.UP * (position.y-Global.water_level) * 0.1)
	$Label.text = str(health, scale, animated_sprite_2d.scale)
	rotation = 0
	scale = Vector2.ONE * (0.5+(health/100))
	print(animated_sprite_2d.material.shader)


#func _on_body_entered(body: Node) -> void:
	#
	#if body.name == "StaticBody2D":
		#hit_floor()


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	print(body, body.is_in_group("player"), body.position.y)
	if body.is_in_group("player") and body.position.y > position.y+20:
		health -= 30
		linear_velocity.y = min(-300, linear_velocity.y)
		
