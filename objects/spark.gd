extends Sprite2D


var target_bubble
@export var movecurve: Curve
var progress = 0
var start_pos

func _ready() -> void:
	start_pos = position
func _process(delta: float) -> void:
	progress += delta
	if progress >= 1:
		queue_free()
	position = lerp(start_pos, target_bubble.position, movecurve.sample(progress))
	
