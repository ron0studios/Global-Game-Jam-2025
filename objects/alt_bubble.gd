extends Node2D

var timer = 0
var size = 1

func _process(delta):
	timer += delta
	position = 5*Vector2(cos(timer), sin(timer)) + get_global_mouse_position()
	scale = Vector2((1 + sin(timer*3)/10), (1 + cos(timer*3)/10)) * size
	queue_redraw()
	size += Input.get_axis("ui_up", "ui_down") * delta

func _draw():
	draw_circle(Vector2.ZERO, 30, Color.WHITE, false, 8.0/(scale.x + scale.y), false)
