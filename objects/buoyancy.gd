extends Node

@onready var parent = get_parent()
func _process(delta: float) -> void:
	if parent.position.y > Global.water_level:
		#uhhh we get to this later
		pass
