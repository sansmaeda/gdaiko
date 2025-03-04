class_name Game
extends TJAParser
##Contains data to be used during the gameplay section. Themes should use this in order to get information about the song.

const FUKA: float = 0.108
const KA: float = 0.075
const RYOU: float = 0.025

var path: String
##Genre of the song. Determines which folder the song appears in.
var genre: String

var data: String

func _init(path: String):
	self.path = path
	parse(path)

##Class containing data used by an individual chart
class Chart:
	
	##Difficulty of the chart. (EG. Oni)
	var course: String
	##Number of stars 
	var level: int
	
	##Array containing balloon int values
	var balloon: Array
	
	##Used for score calculation
	var score_init: int = 100
	var score_diff: int = 100
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
