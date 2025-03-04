extends Node2D

var song_select: SongSelect = SongSelect.new()

func _ready() -> void:
	$'/root'.set_content_scale_size(Vector2i(384, 216))
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("don_right")):
		load_game("/home/sans/.local/share/godot/app_userdata/gdaiko/Songs/03 Vocaloid/Matryoshka/Matryoshka.tja")

func load_game(path: String) -> void:
	Game.active_song = path
	var game: Node2D = load("res://Themes/Default Theme/Game/game.tscn").instantiate()
	game.genre = "Vocaloid"
	get_parent().add_child(game)
	self.queue_free()
	
