extends Node
var title: String
var game: Game = Game.new("res://Songs/Test Song/TestSong.tja")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(game)
	$Title.text = game.title

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
