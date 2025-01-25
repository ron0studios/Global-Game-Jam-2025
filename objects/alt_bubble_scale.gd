extends Node2D


func _draw():
	draw_circle(Vector2.ZERO, 30, Color.WHITE, false, 8.0/(scale.x + scale.y), false)
