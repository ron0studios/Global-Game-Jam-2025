extends ColorRect


func _input(event):
	if event.is_action_pressed("p1_blow"):
		get_tree().change_scene_to_file("res://objects/sandbox.tscn")
