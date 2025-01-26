extends Node

func _process(delta: float) -> void:
	if get_parent().health < 50:
		get_parent().health = 50
