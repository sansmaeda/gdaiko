extends Node2D

var song_select: SongSelect = SongSelect.new()

func _ready() -> void:
	$'/root'.set_content_scale_size(Vector2i(384, 216))
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("don_right")):
		get_tree().change_scene_to_file("res://Themes/Default Theme/Song Select/song_select.tscn")
