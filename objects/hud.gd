extends Control

@onready var duckavatar = preload("res://objects/duckavatar.tscn")
@onready var grid_container = $GridContainer
@onready var timer_timer = $TimerTimer

var clock = 90
var _scale = Vector2.ONE
signal game_over
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.text = seconds2hhmmss(clock)
	for i in range(Global.num_of_players):
		var avatarinst = duckavatar.instantiate()
		avatarinst.player_number = i+1
		avatarinst.modulate = Global.player_colors[i]
		grid_container.add_child(avatarinst)


	



func seconds2hhmmss(total_seconds: float) -> String:
	var seconds:float = fmod(total_seconds , 60.0)
	var minutes:int   =  int(total_seconds / 60.0) % 60
	var hours:  int   =  int(total_seconds / 3600.0)
	var hhmmss_string:String = "%02d:%02d" % [minutes, seconds]
	return hhmmss_string

func _on_timer_timer_timeout() -> void:
	clock -= 1
	if clock <= 0:
		timer_timer.stop()
		emit_signal("game_over")
		for i in grid_container.get_children():
			Global.results[i.player_number-1] = int(i.label.text)
	var tween = get_tree().create_tween()
	$Timer.scale = _scale*1.1
	tween.tween_property($Timer, "scale", _scale,0.1)
	$Timer.text = seconds2hhmmss(clock)
	
	if clock < 10:
		$Timer.modulate = Color.RED
	elif clock < 20:
		$Timer.modulate = Color.ORANGE
	pass # Replace with function body.
