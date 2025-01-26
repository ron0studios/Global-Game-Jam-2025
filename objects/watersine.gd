extends TextureRect


var timer = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	position = Vector2(5*sin(timer*0.5)-294, 3*cos(timer*3)+255)
