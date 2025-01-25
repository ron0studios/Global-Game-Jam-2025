extends ColorRect

#Delete this script if you like

func _process(delta: float) -> void:
	position.y = Global.water_level
