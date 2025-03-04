extends Node2D
class_name SongSelect

var song_number: int

var genres: Array[String]

func _ready():
	var folders = DirAccess.get_directories_at("user://Songs/")
	for folder in folders:
		if FileAccess.file_exists("user://Songs/".path_join(folder).path_join("box.def")):
			genres.append("user://Songs/".path_join(folder).path_join("box.def"))
	for genre in genres:
		var regex = RegEx.create_from_string("(?m)#GENRE:(.*)$")
		print(regex.search(FileAccess.get_file_as_string(genre)).get_string(1))

func get_songs(folder: String):
	pass
