extends Control
@onready var tiles = $TextureRect
@onready var tub = $Tub
@onready var birds = $Tub/birds
@onready var play_button = $CanvasLayer/Button
@onready var players_icon = $CanvasLayer/Players
@onready var player_icons = [
	preload("res://assets/2players.png"),
	preload("res://assets/3players.png"),
	preload("res://assets/4players.png")
]
@onready var howtoplay = $CanvasLayer/Button2

var timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	tiles.position.x = wrap(tiles.position.x + 60*delta, -128, 0)
	tiles.position.y = wrap(tiles.position.y - 60*delta, -128, 0)
	tub.scale = Vector2.ONE * (7+sin(timer*2)*0.1)
	tub.position = Vector2(577, 610) + Vector2(sin(timer*0.5), cos(timer*1))*Vector2(20, 9)
	tub.rotation = sin(timer*0.5)*0.05
	birds.position = Vector2(sin(timer*0.5)*6, cos(timer*1.4)*9)
	birds.rotation = sin(timer*0.5)*0.2
	play_button.position.y = 411 + sin(timer*3.5)*10
	players_icon.position.y = 696 + sin(timer*3.5+1.5)*10
	howtoplay.position.y = 537 + sin(timer*3.5+0.75)*10
	


func _on_button_pressed() -> void:
	print(Global.num_of_players)
	var tweem
	
	get_tree().change_scene_to_file("res://objects/sandbox.tscn")




func _on_h_slider_value_changed(value: float) -> void:
	Global.num_of_players = value




func _on_players_pressed():
	Global.num_of_players = wrap(Global.num_of_players + 1, 2, 5)
	players_icon.icon = player_icons[Global.num_of_players-2]
	players_icon.get_node("AnimationPlayer").stop()
	players_icon.get_node("AnimationPlayer").play("clickwobble")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://objects/howtoplay.tscn")
