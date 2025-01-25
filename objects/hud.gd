extends Control


var clock = 60

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
	$Timer.text = seconds2hhmmss(clock)
	pass # Replace with function body.
