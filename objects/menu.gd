extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	print(Global.num_of_players)
	get_tree().change_scene_to_file("res://objects/sandbox.tscn")




func _on_h_slider_value_changed(value: float) -> void:
	Global.num_of_players = value
