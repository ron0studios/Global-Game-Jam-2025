extends Control


var clock = 30
var _scale = Vector2.ONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.text = seconds2hhmmss(clock)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func seconds2hhmmss(total_seconds: float) -> String:
	var seconds:float = fmod(total_seconds , 60.0)
	var minutes:int   =  int(total_seconds / 60.0) % 60
	var hours:  int   =  int(total_seconds / 3600.0)
	var hhmmss_string:String = "%02d:%02d" % [minutes, seconds]
	return hhmmss_string

func _on_timer_timer_timeout() -> void:
	clock -= 1
	var tween = get_tree().create_tween()
	$Timer.scale = _scale*1.1
	tween.tween_property($Timer, "scale", _scale,0.1)
	$Timer.text = seconds2hhmmss(clock)
	
	if clock < 10:
		$Timer.modulate = Color.RED
	elif clock < 20:
		$Timer.modulate = Color.ORANGE
	pass # Replace with function body.
