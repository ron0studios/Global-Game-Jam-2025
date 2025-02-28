extends Node2D

var timer = 0
var size = 1
@onready var scale_node: Node2D = $ScaleNode

func _process(delta):
	timer += delta
	position = 5*Vector2(cos(timer), sin(timer)) + get_global_mouse_position()
	scale_node.scale = Vector2((1 + sin(timer*3)/4), (1 + cos(timer*3)/4)) * size
	queue_redraw()
	size += Input.get_axis("ui_up", "ui_down") * delta

func _draw():
	draw_circle(scale_node.scale*Vector2(10, -10), 6, Color.WHITE, true)
