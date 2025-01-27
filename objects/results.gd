extends ColorRect

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d_2 = $Sprite2D2
@onready var label = $Label
var graph_visible = false
var best = -1
var timer = 0
@onready var froth = preload("res://objects/froth.tscn")

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

func _process(delta):
	timer += delta*3
	sprite_2d_2.frame = int(timer)%2

func enable_graph():
	graph_visible = true
	queue_redraw()
	for i in range(1,(Global.num_of_players+1)):
		var froth_inst = froth.instantiate()
		froth_inst.position =Vector2((i+0.5)*150, 900 - (700*Global.results[i-1]/float(best)))
		froth_inst.play("default")
		add_child(froth_inst)
		froth_inst.z_index = 5
		print(froth_inst)

func back_to_title():
	get_tree().change_scene_to_file("res://objects/menu.tscn")

func _draw():
	if graph_visible:
		for i in range(1, 5):
			var col = Global.player_colors[i-1]
			if i>Global.num_of_players:
				col = Color(0.3, 0.3, 0.3)
			else:
				var l = Label.new()
				l.text = str(Global.results[i - 1])
				l.position.x = i*150 + 75 - str(Global.results[i-1]).length() * 12
				l.position.y = 900 + 30 
				l.vertical_alignment = VERTICAL_ALIGNMENT_TOP
				l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				l.add_theme_font_override("font",load("res://fonts/Kenney Pixel.ttf"))
				l.add_theme_font_size_override("font_size",50)
				add_child(l)
			
			if i <= Global.num_of_players:
				draw_rect(Rect2(Vector2(i*150, 900), Vector2(150, -700)), col.darkened(0.7))
				draw_rect(Rect2(Vector2(i*150, 900), Vector2(150, -700*(Global.results[i-1]/float(best)))), col)
