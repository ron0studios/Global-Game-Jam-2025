extends Node2D

@onready var bubble_scene = preload("res://objects/bubble.tscn")


func _on_timer_timeout() -> void:
	if randi_range(0,2) == 0:
		make_bubble()
	

func make_bubble():
	var bubble_inst = bubble_scene.instantiate()
	bubble_inst.health = 1
	bubble_inst.position.x = randi_range(-200,200)
	add_child(bubble_inst)
	
	
