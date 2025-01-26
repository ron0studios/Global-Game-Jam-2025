extends Sprite2D


var target_bubble
@export var movecurve: Curve
var progress = 0
var start_pos

func _process(delta: float) -> void:
	progress += delta
	if progress >= 1:
		queue_free()
	print(target_bubble.position)
	position = start_pos.lerp(target_bubble.position, movecurve.sample(progress))
	
func set_target(target):
	target_bubble = target
