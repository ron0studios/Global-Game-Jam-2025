extends ColorRect
@onready var duckavatar = $HBoxContainer/duckavatar
@onready var label = $HBoxContainer/Label
var ducks = {
	"normal" : preload("res://assets/iconbase.png"),
	"happy" : preload("res://assets/iconbase_happy.png"),
	"hurt" : preload("res://assets/iconbase_hurt.png"),
	"sad" : preload("res://assets/iconbase_sad.png")
}
var last_value = 50
var player_number
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_tree().get_nodes_in_group("player"):
		if i.player_number == player_number:
			player = i
	if player == null:
		queue_free()

func _process(delta):
	#modulate = player.modulate
	label.text = str(max(floor(player.player_bubble.health)-50, 0))#player_bubble.health-50)
	pass


func _on_timer_timeout():
	var curr_value = player.player_bubble.health
	var diff = curr_value - last_value
	if diff < -20:
		duckavatar.texture = ducks["sad"]
	else:
		if diff < 0:
			duckavatar.texture = ducks["hurt"]
		else:
			if diff > 20:
				duckavatar.texture = ducks["happy"]
			else:
				duckavatar.texture = ducks["normal"]

	last_value = curr_value
