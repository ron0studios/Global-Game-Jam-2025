extends Node

@onready var parent = get_parent()
func _process(delta: float) -> void:
	if parent.position.y > Global.water_level:
		parent.velocity.y = (parent.velocity.y + delta * parent.position.y-Global.water_level*0.4) * 0.8
