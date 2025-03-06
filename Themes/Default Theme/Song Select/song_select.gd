extends Node2D
class_name SongSelect

var genres: Array[Genre]
var selected_genre: int = 0
var selected_song: int = 0
#Represents whether the menu is in genre or song selector
var focused: bool = false
var song_list: Array[Song]

var _close_freq: int = 7

func _ready():
	var folders = DirAccess.get_directories_at("user://Songs/")
	for folder in folders:
		var path = "user://Songs/".path_join(folder)
		if FileAccess.file_exists(path.path_join("box.def")):
			var new_genre: Genre = Genre.new()
			new_genre.path = path
			new_genre.title = get_genre_text(path)
			genres.append(new_genre)

func _process(_delta):
	if !focused:
		if(Input.is_action_just_pressed("p1_ka_left")):
			selected_genre -= 1
			$AnimationPlayer.stop()
			$AnimationPlayer.play("move_backward")
		if(Input.is_action_just_pressed("p1_ka_right")):
			selected_genre += 1
			$AnimationPlayer.stop()
			$AnimationPlayer.play("move_forward")
		for h in $Headers.get_children():
			set_genre_data(h)
			
		if Input.is_action_just_pressed("p1_don_right"): focused = true
	else: #focused
		song_list = get_songs(genres[selected_genre].path)
		if(Input.is_action_just_pressed("p1_ka_left")):
			selected_song -= 1
			$AnimationPlayer.stop()
			$AnimationPlayer.play("move_backward")
		if(Input.is_action_just_pressed("p1_ka_right")):
			selected_song += 1
			$AnimationPlayer.stop()
			$AnimationPlayer.play("move_forward")
		
		$"Headers/Header -3/Label".text = genres[(selected_genre-3) % genres.size()-1].title
		$"Headers/Header -2/Label".text = genres[(selected_genre-2) % genres.size()-1].title
		$"Headers/Header -1/Label".text = genres[(selected_genre-1) % genres.size()-1].title
		$"Headers/Header 0/Label".text = genres[(selected_genre)% genres.size()-1].title
		$"Headers/Header 1/Label".text = genres[(selected_genre+1) % genres.size()-1].title
		$"Headers/Header 2/Label".text = genres[(selected_genre+2) % genres.size()-1].title
		$"Headers/Header 3/Label".text = genres[(selected_genre+3) % genres.size()-1].title
		if(Input.is_action_just_pressed("p1_don_right")):
			load_game(song_list[selected_song].path)

func set_genre_data(header: Node2D) -> void:
	var title = genres[(selected_genre+header.get_index()-3) % (genres.size()-1)].title.strip_edges()
	header.get_child(2).text = title
	match title:
			"J-POP":
				header.get_child(0).self_modulate = Color("42c0d3")	
				header.get_child(1).self_modulate = Color("aae3ea")
			"アニメ":
				header.get_child(0).self_modulate = Color("ff90d2")
				header.get_child(1).self_modulate = Color("ffcdeb")
			"ボーカロイド", "VOCALOID":
				header.get_child(0).self_modulate = Color("cccfde")
				header.get_child(1).self_modulate = Color("e7e8f3")
			"どうよう":
				header.get_child(0).self_modulate = Color("fec000")
				header.get_child(1).self_modulate = Color("ffe38d")
			"バラエティ", "バラエティー":
				header.get_child(0).self_modulate = Color("1ec83b")
				header.get_child(1).self_modulate = Color("9ae6a7")
			"クラシック":
				header.get_child(0).self_modulate = Color("cac101")
				header.get_child(1).self_modulate = Color("e6e38b")
			"ゲームミュージック":
				header.get_child(0).self_modulate = Color("cb89e8")
				header.get_child(1).self_modulate = Color("e8cbf6")
			"ナムコオリジナル":
				header.get_child(0).self_modulate = Color("ff7028")
				header.get_child(1).self_modulate = Color("ffc09e")
			_:
				header.get_child(0).self_modulate = Color("ffffff")
				header.get_child(1).self_modulate = Color("ffffff")

func get_songs(path: String) -> Array[Song]:
	var rtn: Array[Song]
	for folder in DirAccess.get_directories_at(path):
		for file in DirAccess.get_files_at(path.path_join(folder)):
			if(file.ends_with(".tja")):
				var new_song: Song = Song.new()
				new_song.path = path.path_join(folder).path_join(file)
				var parser: TJAParser = TJAParser.new()
				parser.parse(new_song.path)
				new_song.title = parser.title
				rtn.append(new_song)
	return rtn

func get_genre_text(path: String):
	var regex = RegEx.create_from_string("(?m)^#GENRE:(.*)$")
	return regex.search(FileAccess.get_file_as_string(path.path_join("box.def"))).get_string(1)

func load_game(path: String) -> void:
	var game: Node2D = load("res://Themes/Default Theme/Game/game.tscn").instantiate()
	BackgroundData.active_song = path
	get_parent().add_child(game)
	self.queue_free()

class Genre: 
	var path: String
	var title: String
class Song:
	var path: String
	var title: String
