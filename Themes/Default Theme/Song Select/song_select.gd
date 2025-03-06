extends Node2D
class_name SongSelect

var genres: Array[Genre]
var selected_genre: int = 0:
	get:
		return selected_genre % genres.size()
var selected_song: int = 0:
	get:
		if focused:
			return selected_song % (song_list.size()+1+ceil(selected_song/_close_freq))
		else:
			return selected_song
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

func _input(event):
	if !focused:
		if event.is_action_pressed("p1_ka_left"):
			selected_genre -= 1
			$AnimationPlayer.stop()
			$AnimationPlayer.play("move_backward")
		if(event.is_action_pressed("p1_ka_right")):
				selected_genre += 1
				$AnimationPlayer.stop()
				$AnimationPlayer.play("move_forward")
		for h in $Headers.get_children():
			set_genre_data(h)
		if event.is_action_pressed("p1_don_right"): focused = true
	else: #focused
		song_list = get_songs(genres[selected_genre%genres.size()].path)
		if(event.is_action_pressed("p1_ka_left")):
			selected_song -= 1
			$AnimationPlayer.stop()
			$AnimationPlayer.play("move_backward")
		if(event.is_action_pressed("p1_ka_right")):
			selected_song += 1
			$AnimationPlayer.stop()
			$AnimationPlayer.play("move_forward")
		for h in $Headers.get_children():
			set_song_data(h)
		if(event.is_action_pressed("p1_don_right")):
			if selected_song < 0 || selected_song > song_list.size():
				selected_genre += selected_song
				selected_genre = selected_genre % genres.size()
				selected_song = 0
			elif(selected_song % _close_freq == 0):
				selected_song = 0
				focused = false
			else:
				load_game(song_list[selected_song-ceil(selected_song/_close_freq)-1].path)

func _process(_delta):
	pass

func get_color_data(genre: String) -> Array[Color]:
	match genre:
			"J-POP":
				return [Color("42c0d3"), Color("aae3ea")]
			"アニメ":
				return [Color("ff90d2"), Color("ffcdeb")]
			"ボーカロイド", "VOCALOID":
				return [Color("cccfde"), Color("e7e8f3")]
			"どうよう":
				return [Color("fec000"), Color("ffe38d")]
			"バラエティ", "バラエティー":
				return [Color("1ec83b"), Color("9ae6a7")]
			"クラシック":
				return [Color("cac101"), Color("e6e38b")]
			"ゲームミュージック":
				return [Color("cb89e8"), Color("e8cbf6")]
			"ナムコオリジナル":
				return [Color("ff7028"), Color("ffc09e")]
			_:
				return [Color("ffffff"), Color("ffffff")]

func set_genre_data(header: Node2D) -> void:
	var title = genres[(selected_genre+header.get_index()-3+selected_song) % genres.size()].title.strip_edges()
	header.get_child(0).self_modulate = get_color_data(title)[0]
	header.get_child(1).self_modulate = get_color_data(title)[1]
	header.get_child(2).text = title

func set_song_data(header: Node2D) -> void:
	var type: String
	var offset = header.get_index()-3
	var cancel_count: int = ceil(selected_song/_close_freq)
	if selected_song+offset < 0 || selected_song+offset-ceil(selected_song/_close_freq) > song_list.size():
		set_genre_data(header)
	elif (selected_song+offset) % _close_freq == 0:
		header.get_child(2).text = "Close"
		header.get_child(0).self_modulate = Color("000000")
	else:
		var parser = TJAParser.new()
		print(selected_song+offset-ceil(selected_song/_close_freq))
		parser.parse(song_list[selected_song+offset-ceil(selected_song/_close_freq)-1].path)
		header.get_child(2).text = parser.title
		header.get_child(0).self_modulate = get_color_data(genres[selected_genre].title.strip_edges())[0]
		header.get_child(1).self_modulate = get_color_data(genres[selected_genre].title.strip_edges())[1]

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
