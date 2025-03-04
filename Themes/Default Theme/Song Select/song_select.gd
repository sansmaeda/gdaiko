extends Node2D
class_name SongSelect

var genres: Array[String]
var selected_genre: int = 0
var selected_song: int = 0
var focused: bool = false

func _ready():
	var folders = DirAccess.get_directories_at("user://Songs/")
	for folder in folders:
		if FileAccess.file_exists("user://Songs/".path_join(folder).path_join("box.def")):
			genres.append("user://Songs/".path_join(folder))
	print(genres)

func _process(_delta):
	if !focused:
		if(Input.is_action_just_pressed("ka_left")):
			selected_genre -= 1
		if(Input.is_action_just_pressed("ka_right")):
			selected_genre += 1
		if(selected_genre < 0): selected_genre = genres.size()-1
		if(selected_genre > genres.size()-1): selected_genre = 0
		$"Header 4 (Selected)/Label".text = get_genre_text(genres[selected_genre])
		if Input.is_action_just_pressed("don_right"): focused = true
	if focused:
		var song_list: Array[String] = get_songs(genres[selected_genre])
		print(song_list)
		if(Input.is_action_just_pressed("ka_left")):
			selected_song -= 1
		if(Input.is_action_just_pressed("ka_right")):
			selected_song += 1
		if(selected_song < 0): selected_song = genres.size()-1
		if(selected_song > genres.size()-1): selected_song = 0
		var parser: TJAParser = TJAParser.new()
		parser.parse(song_list[selected_song])
		$"Header 4 (Selected)/Label".text = parser.title

func get_songs(path: String) -> Array[String]:
	var rtn: Array[String]
	for folder in DirAccess.get_directories_at(path):
		for file in DirAccess.get_files_at(path.path_join(folder)):
			if(file.ends_with(".tja")):
				rtn.append(path.path_join(folder).path_join(file))
	return rtn

func get_genre_text(path: String):
	var regex = RegEx.create_from_string("(?m)#GENRE:(.*)$")
	return regex.search(FileAccess.get_file_as_string(path.path_join("box.def"))).get_string(1)
