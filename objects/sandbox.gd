extends Node2D

@onready var animation_player = $AnimationPlayer

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
@onready var bubble_scene = preload("res://objects/bubble.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("curtainopen")
	make_bubble(-100)
	make_bubble(-300)
	make_bubble(-500) # Replace with function body.

func _on_timer_timeout() -> void:
	if randi_range(0,3) == 0:
		for i in randi_range(1,2):
			make_bubble(-700)
			await get_tree().create_timer(0.1).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func make_bubble(start_y):
	var bubble_inst = bubble_scene.instantiate()
	bubble_inst.health = 0.1
	bubble_inst.position.x = randi_range(-200,200)
	bubble_inst.position.y = start_y
	add_child(bubble_inst)

func game_over():
	timer.stop()
	animation_player.play_backwards("curtainopen")
	get_tree().paused = true
	await get_tree().create_timer(2).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://objects/results.tscn")
