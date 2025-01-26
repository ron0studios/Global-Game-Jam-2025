extends ColorRect
@onready var label = $HBoxContainer/Label


var player_number
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_tree().get_nodes_in_group("player"):
		if i.player_number == player_number:
			player = i
	print(player, player_number)

func _process(delta):
	#modulate = player.modulate
	#label.text = str(player.player_bubble.health-50)
	pass
