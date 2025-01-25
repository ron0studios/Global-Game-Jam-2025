extends AnimatedSprite2D

@export var health = 100

var states = ["default","happy","sad","angry","hurt"]
var curstate = 0



func set_anim(val):
	var trans = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC)
	var _scale = scale
	trans.tween_property(self, "scale", _scale*1.3, 0.01)
	trans.tween_property(self, "scale", _scale, 0.2)
	match val:
		0:
			default()
		1:
			happy()
		2:
			sad()
		3:
			angry()
		4:
			hurt()


func default():
	animation="default"

func happy():
	animation="happy"

func sad():
	animation="sad"

func angry():
	animation="angry"

func hurt():
	animation="hurt"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass


func _on_dbgtimer_timeout() -> void:
	curstate += 1
	curstate %= 5
	set_anim(curstate)
	pass # Replace with function body.
