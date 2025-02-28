extends Node
class_name Game
##Handles game logic. Themes should use this in order to get the game state.

const FUKA: float = 0.108
const KA: float = 0.075
const RYOU: float = 0.025

var path: String

var title: String
var title_ja: String
var title_en: String
var subtitle: String
var subtitle_ja: String
var subtitle_en: String

var _parser: TJAParser

var chart_easy: Chart
var chart_normal: Chart
var chart_hard: Chart
var chart_edit: Chart

var wave: String
var offset: float
var bpm: float
var head_scroll: float = 1
var data: String

var score_mode: int


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
	
	chart_easy = _parser.chart_easy
	chart_normal = _parser.chart_normal
	chart_hard = _parser.chart_hard
	chart_edit = _parser.chart_edit
	
	wave = _parser.wave
	offset = _parser.offset
	bpm = _parser.bpm
	
	score_mode = _parser.score_mode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

##Class containing data used by an individual chart
class Chart:
	
	##Difficulty of the chart. (EG. Oni)
	var course: String
	##Number of stars 
	var level: int
	
	##Array containing balloon int values
	var balloon: Array
	
	##Used for score calculation
	var score_init: int
	var score_diff: int
	var style: String
	
	##Dojo bars
	var exam1: Array
	var exam2: Array
	var exam3: Array
	
	##Rounding method for gauge
	var gauge_incr: String
	##Percentage multiplier for notes effectiveness in gauge
	var total: float
	var hidden_branch: bool
	
	##Contains the actual data of the chart
	var data: String
