extends Node
class_name Game
##Handles game logic. Themes should use this in order to get the game state.

var path: String

var title: String
var title_ja: String
var title_en: String
var subtitle: String
var subtitle_ja: String
var subtitle_en: String

var _score_p1: Score
var _score_p2: Score
var _parser: TJAParser

func _init(path: String):
	self.path = path

# Called when the node enters the scene tree for the first time.
func _ready():
	_parser = TJAParser.new()
	_parser.parse(path)
	
	title = _parser.title
	title_ja = _parser.title_ja
	title_en = _parser.title_en
	subtitle = _parser.subtitle
	subtitle_ja = _parser.subtitle_ja
	subtitle_en = _parser.subtitle_en
	print(title)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
