extends AnimatedSprite2D
func _ready():
	$AudioStreamPlayer.stream = load("res://audio/pop%s.mp3" % str(randi_range(1, 3)))
	$AudioStreamPlayer.pitch_scale = randf_range(0.8, 1.2)
	$AudioStreamPlayer.play()
func _on_animation_finished() -> void:
	queue_free()
