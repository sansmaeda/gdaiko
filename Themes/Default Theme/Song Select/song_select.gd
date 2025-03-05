extends Node2D
class_name SongSelect

var genres: Array[Genre]
var selected_genre: int = 0:
	set(value):
		if(value < 0): selected_genre = genres.size()-1
		elif(value > genres.size()-1): selected_genre = 0
		else: selected_genre = value
var selected_song: int = 0:
	set(value):
		if(value < 0): selected_song = song_list.size()-1
		elif(value > song_list.size()-1): selected_song = 0
		else: selected_song = value
#Represents whether the menu is in genre or song selector
var focused: bool = false
var song_list: Array[Song]

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
		if(Input.is_action_just_pressed("p1_ka_right")):
			selected_genre += 1
			$AnimationPlayer.stop()
			$AnimationPlayer.play("move_forward")
		$"Header 0/Label".text = genres[selected_genre].title
		if(selected_genre-1 < 0):
			$"Header -1/Label".text = genres[genres.size()-1].title
		elif(selected_genre-1 > genres.size()-1):
			$"Header -1/Label".text = genres[0].title
		else:
			$"Header -1/Label".text = genres[selected_genre-1].title
		if Input.is_action_just_pressed("p1_don_right"): focused = true
	else:
		song_list = get_songs(genres[selected_genre].path)
		if(Input.is_action_just_pressed("p1_ka_left")):
			selected_song -= 1
		if(Input.is_action_just_pressed("p1_ka_right")):
			selected_song += 1
		
		$"Header 0/Label".text = song_list[selected_song].title
		if(Input.is_action_just_pressed("p1_don_right")):
			load_game(song_list[selected_song].path)

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
