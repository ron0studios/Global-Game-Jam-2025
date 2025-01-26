extends Node2D
@onready var label: Label = $CanvasLayer/VBoxContainer/HBoxContainer/Label
@onready var btnDecrease: Button = $CanvasLayer/VBoxContainer/HBoxContainer/Button
@onready var btnIncrease: Button = $CanvasLayer/VBoxContainer/HBoxContainer/Button2


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



func _on_button_2_button_up() -> void:
	if Global.num_of_players < 4:
		Global.num_of_players = Global.num_of_players + 1
		label.text = str(Global.num_of_players)
	if Global.num_of_players == 4:
		btnIncrease.disabled = true
	btnDecrease.disabled = false
		


func _on_button_button_up() -> void:
	if Global.num_of_players > 1:
		Global.num_of_players = Global.num_of_players - 1
		label.text = str(Global.num_of_players)
	if Global.num_of_players == 1:
		btnDecrease.disabled = true
	btnIncrease.disabled = false
