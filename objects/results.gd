extends ColorRect

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d_2 = $Sprite2D2
@onready var label = $Label
var graph_visible = false
var best = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("winner")
	var winner = 0
	for i in range(Global.num_of_players):
		if Global.results[i] > best:
			best = Global.results[i]
			winner = i
	sprite_2d_2.modulate = Global.player_colors[winner]
	label.text = str("Player ", winner+1, " wins!")

func enable_graph():
	graph_visible = true
	queue_redraw()

func back_to_title():
	get_tree().change_scene_to_file("res://objects/menu.tscn")

func _draw():
	if graph_visible:
		for i in range(1, 5):
			var col = Global.player_colors[i-1]
			if i>Global.num_of_players:
				col = Color(0.3, 0.3, 0.3)
			draw_rect(Rect2(Vector2(i*150, 900), Vector2(150, -700)), col.darkened(0.7))
			draw_rect(Rect2(Vector2(i*150, 900), Vector2(150, -700*(Global.results[i-1]/float(best)))), col)
