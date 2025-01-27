extends Node2D


func _process(delta: float) -> void:
	var Bscale
	#if get_parent().health <= 150:
		#Bscale = 0.5 + get_parent().health/100.0
	#else:
	Bscale = 0.65 + log(get_parent().health/120.0 + 1)
	scale = Vector2.ONE * Bscale
