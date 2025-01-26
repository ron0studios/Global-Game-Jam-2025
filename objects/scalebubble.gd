extends Node2D


func _process(delta: float) -> void:
	print()
	scale = Vector2.ONE * (0.5+(get_parent().health/100.0))
