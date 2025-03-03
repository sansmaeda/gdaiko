extends Node

var song_list: Array[SongData] #Populated by src/Intro/intro.gd

func load_songs() -> void:
	#Genres
	DirAccess.make_dir_absolute("user://Songs/")
	for dir in DirAccess.get_directories_at("user://Songs/"):
		if(FileAccess.file_exists("user://Songs/" + dir.path_join("box.def"))):
			var box = FileAccess.open("user://Songs/" + dir.path_join("box.def"), FileAccess.READ).get_as_text()
			var regex = RegEx.create_from_string(r'(?m)^#GENRE:(.*)$')
			var genre = regex.search(box).get_string(1)
			
			for song in DirAccess.get_directories_at("user://Songs/"+dir):
				var path: String
				for file in DirAccess.get_files_at("user://Songs/"+dir.path_join(song)):
					if file.ends_with(".tja"):
						path = "user://Songs/"+dir.path_join(song).path_join(file)
				var new_song: SongData = SongData.new()
				new_song.genre = genre
				new_song.tja_path = path
				song_list.append(new_song)
				print(song_list[-1].genre)
				print(song_list[-1].tja_path)
			
class SongData:
	var tja_path: String
	var genre: String
