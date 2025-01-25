extends Node#NOTE: Add any global stuff here! This persists across scenes.
#Refer to the attributes with Global.attribute_name
@export var water_level = 300
var timer = 0
#func _process(delta: float) -> void:
	#timer += delta
	#water_level = 300 + sin(timer)*100
