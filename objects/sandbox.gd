extends Node2D


# Called when the node enters the scene tree for the first time.
@onready var bubble_scene = preload("res://objects/bubble.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_bubble(-100)
	make_bubble(-300)
	make_bubble(-500) # Replace with function body.

func _on_timer_timeout() -> void:
	if randi_range(0,2) == 0:
		for i in randi_range(1,2):
			make_bubble(-700)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func make_bubble(start_y):
	var bubble_inst = bubble_scene.instantiate()
	bubble_inst.health = 1
	bubble_inst.position.x = randi_range(-200,200)
	bubble_inst.position.y = start_y
	add_child(bubble_inst)
