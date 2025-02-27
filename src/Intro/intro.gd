extends Node2D

var config: ConfigFile = ConfigFile.new()

func _ready() -> void:
	#Load config
	if(FileAccess.file_exists("user://global.cfg")):
		config.load("user://global.cfg")
	else:
		config.set_value("General", "Theme", "Default Theme")
		config.save("user://global.cfg")
	var theme_dir = config.get_value("General", "Theme")
	if(DirAccess.dir_exists_absolute("user://Themes/")):
		for i in DirAccess.get_files_at("user://Themes/"):
			ProjectSettings.load_resource_pack(i)
	else: (DirAccess.make_dir_absolute("user://Themes/"))
	
	get_tree().call_deferred("change_scene_to_file", "res://Themes/" + theme_dir + "/main.tscn")
