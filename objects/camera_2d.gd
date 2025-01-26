extends Camera2D



func _ready() -> void:
	zoom = Vector2.ONE * 2
	position.x = 0
	position.y = Global.water_level - 20

func _process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("player")
	var avg_pos = Vector2.ZERO
	var max_dist = 0
	var min_dist = 350
	for i in players:
		avg_pos.y += i.position.y
		#var dist = position.distance_to(get_node(i).position)
		#max_dist = max(max_dist, position.distance_to(get_node(i).position))
		
		
	avg_pos /= len(players)
	if avg_pos.y < -300:
		avg_pos.y = -300
	if avg_pos.y > Global.water_level - 20:
		avg_pos.y = Global.water_level - 20 
	position = position.lerp(avg_pos, 1 - pow(delta, 0.08))
	#if max_dist > 500:
		#max_dist = 500
	#zoom = zoom.lerp(Vector2.ONE*700/max(min_dist, max_dist), 1 - pow(delta, 0.3))
