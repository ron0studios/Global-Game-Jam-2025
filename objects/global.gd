extends Node#NOTE: Add any global stuff here! This persists across scenes.
#Refer to the attributes with Global.attribute_name
@export var water_level = 263
@export var wall_limit = 300
var timer = 0
var num_of_players = 2
#func _process(delta: float) -> void:
	#timer += delta
	#water_level = 300 + sin(timer)*100
var player_colors = [
	Color.WHITE,
	Color.PALE_VIOLET_RED,
	Color.CORNFLOWER_BLUE,
	Color.PALE_GREEN
	]
