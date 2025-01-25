extends RigidBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var hp = 100

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var fall_speed = 150
var prev_velocity
var base_scale = Vector2.ONE*0.5
signal hit

func _ready() -> void:
	animated_sprite_2d.play("default")

func hit_floor():
	var wobble = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
	#$Sprite2D.scale = Vector2(1.2,1.2)
	$CPUParticles2D.emitting = true
	hit.emit()
	pass

func _physics_process(delta: float) -> void:
	if position.y > Global.water_level:
		hp -= delta * 10
		apply_impulse(Vector2.UP * (position.y-Global.water_level) * 0.1)
	$Label.text = str(hp)
	rotation = 0
	modulate = Color.RED.lerp(Color.WHITE, hp/100.0)
	


func _on_body_entered(body: Node) -> void:
	
	if body.name == "StaticBody2D":
		hit_floor()


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	print(body, body.is_in_group("player"), body.position.y)
	if body.is_in_group("player") and body.position.y > position.y+20:
		hp -= 30
		linear_velocity.y = min(-300, linear_velocity.y)
