extends Node2D

var config: ConfigFile = ConfigFile.new()
var theme_dir: String

func _ready() -> void:
	#Load config
	if(FileAccess.file_exists("user://global.cfg")):
		config.load("user://global.cfg")
	else:
		config.set_value("General", "Theme", "Default Theme")
		config.save("user://global.cfg")
	theme_dir = config.get_value("General", "Theme")
	if(DirAccess.dir_exists_absolute("user://Themes/")):
		for i in DirAccess.get_files_at("user://Themes/"):
			ProjectSettings.load_resource_pack(i)
	else: (DirAccess.make_dir_absolute("user://Themes/"))
	if(!config.has_section_key("General", "Locale")):
		config.set_value("General", "Locale", OS.get_locale_language())
		config.save("user://global.cfg")
	TranslationServer.set_locale(config.get_value("General", "Locale"))
	
	get_tree().call_deferred("change_scene_to_file", "res://Themes/" + theme_dir + "/main.tscn")
