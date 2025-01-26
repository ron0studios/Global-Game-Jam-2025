extends Node

func _process(delta: float) -> void:
	if get_parent().health < 50:
		get_parent().health = 50
	if get_parent().linear_velocity.y > 0:
		get_parent().linear_damp = 5
	else:
		get_parent().linear_damp = 2
	
