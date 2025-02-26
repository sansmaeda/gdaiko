extends Node
var title: String

# Called when the node enters the scene tree for the first time.
func _ready():
	var parser: TJAParser = TJAParser.new()
	parser.parse("res://Songs/Test Song/TestSong.tja")
	parser.print()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
