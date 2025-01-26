extends Node2D


# Called when the node enters the scene tree for the first time.
@onready var bubble_scene = preload("res://objects/bubble.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	if randi_range(0,2) == 0:
		make_bubble()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func make_bubble():
	var bubble_inst = bubble_scene.instantiate()
	bubble_inst.health = 1
	bubble_inst.position.x = randi_range(-200,200)
	add_child(bubble_inst)
