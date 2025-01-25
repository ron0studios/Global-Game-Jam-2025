extends Camera2D


@export var targets : Array[NodePath]

func _process(delta: float) -> void:
	var avg_pos = Vector2.ZERO
	var max_dist = 0
	for i in targets:
		avg_pos += get_node(i).position
	avg_pos /= len(targets)
	for i in targets:
		max_dist = max(max_dist, position.distance_to(get_node(i).position))
	position = position.lerp(avg_pos, 1 - pow(delta, 0.1))
	zoom = zoom.lerp(Vector2.ONE*700/max(200, max_dist), 1 - pow(delta, 0.2))
