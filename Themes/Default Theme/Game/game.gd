extends Node
var title: String
var song_data: TJAParser = TJAParser.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	song_data.parse("res://Songs/Test Song/TestSong.tja")
	song_data.print()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
