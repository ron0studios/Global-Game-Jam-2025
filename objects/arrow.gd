extends Sprite2D

@export var bubble: RigidBody2D
var buffer = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func in_screen():
	return \
		bubble.global_position.x < get_viewport().size.x + buffer and \
		bubble.global_position.x > 0 - buffer and \
		bubble.global_position.y > 0 - buffer and \
		bubble.global_position.y < get_viewport().size.y + buffer
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !in_screen():
		show()
		rotate(deg_to_rad(90) + get_angle_to(bubble.global_position))
		global_position.x = clamp(bubble.global_position.x, 20, get_viewport().size.x-20)
		global_position.y = clamp(bubble.global_position.y, 20, get_viewport().size.y-20)
	else:
		hide()
		#rotation = deg_to_rad(90)+ get_angle_to(bubble.global_position)
	
	pass
