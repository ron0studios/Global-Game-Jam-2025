extends Area2D

#This doesn't necessarily have to be a spike idk just something that appears
#from the edges of the screen

var speed = 200
var appear = false
var disappear = false
var destination1
var destination2

signal kill
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	destination1 = Vector2(position.x, position.y-70)
	destination2 = global_position
	$Sprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move(delta)

func move(delta):
	if appear:
		global_position = global_position.move_toward(destination1, delta*speed)
	
	if disappear:
		global_position = global_position.move_toward(destination2, delta*speed)
	

func _on_body_entered(body: Node2D) -> void:
	if body.name == "bubble":
		emit_signal("kill")


func _on_timer_timeout() -> void:
	if appear:
		$Timer.wait_time = randi_range(5, 30)
		$Timer.start()
		appear = false
		disappear = true
	else:
		disappear = false
		appear = true
		$Timer.wait_time = 5
		$Timer.start()
