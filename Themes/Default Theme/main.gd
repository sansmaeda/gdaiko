extends Node2D

var song_select: SongSelect = SongSelect.new()

func _ready() -> void:
	$'/root'.set_content_scale_size(Vector2i(384, 216))
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("don_right")):
		load_game("user://Songs/Test/Test Song/TestSong.tja")

func load_game(path: String) -> void:
	var game: Node2D = load("res://Themes/Default Theme/Game/game.tscn").instantiate()
	BackgroundData.active_song = path
	get_parent().add_child(game)
	self.queue_free()
	
