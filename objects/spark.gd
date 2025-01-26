extends Sprite2D


var target_bubble
@export var movecurve: Curve
var progress = 0
var start_pos

func _process(delta: float) -> void:
	progress += delta
	if progress >= 1:
		target_bubble.health += 20
		target_bubble.get_node("Collect").play()
		target_bubble.get_node("Collect").pitch_scale = clamp((target_bubble.health+300)/400.0, 0.8, 2.5)
		queue_free()
	position = start_pos.lerp(target_bubble.position, movecurve.sample(progress))
	
func set_target(target):
	target_bubble = target
