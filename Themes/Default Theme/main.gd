extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$'/root'.set_content_scale_size(Vector2i(384, 216))
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	get_tree().call_deferred("change_scene_to_file", "res://Themes/Default Theme/Game/game.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
