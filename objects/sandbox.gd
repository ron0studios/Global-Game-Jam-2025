extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Water.apply_force($Player.global_position, 128.0 * Vector2.DOWN, 10.0)
	pass
