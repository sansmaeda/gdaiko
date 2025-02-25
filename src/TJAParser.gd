# https://github.com/269Seahorse/Better-taiko-web/blob/master/TJA-format.mediawiki
# https://outfox.wiki/en/dev/mode-support/tja-support
class_name TJAParser
extends Node

#region Song Metadata Variables
##Title of the song. (Default)
var Title: String
##Title of the song. (Japanese)
var TitleJP: String
##Title of the song. (English)
var TitleEN: String
##Title of the song. (Simplified Chinese)
var TitleCN: String
##Title of the song. (Traditional Chinese)
var TitleTW: String
##Title of the song. (Korean)
var TitleKO: String

##Subtitle of the song. (Default)
var Subtitle: String
var SubtitleJP: String
var SubtitleEN: String
var SubtitleCN: String
var SubtitleTW: String
var SubtitleKO: String

##Initial BPM of the song.
var BPM: float = 120
##Path to the song audio file used during gameplay. Located in the same folder as the TJA.
var Wave: String
##Offset of the notes in seconds.
var Offset: float 
var DemoStart: float

var Genre: String
var ScoreMode: int = 1
var Maker: String
#var Lyrics: String
var SongVol: float = 100
var SEVol: float = 100
var Side: String #???
var Life: int = 0
var Game: String = "Taiko"
var HeadScroll: float = 1 #Speed multiplier?

var BGImage: String
var BGMovie: String
var MovieOffset: float
#endregion

#region Course Metadata Variables
var Course: String
var Level: int

var Balloon: Array
var BalloonNor: Array
var BalloonExp: Array
var BalloonMas: Array

var ScoreInit: int
var ScoreDiff: int
var Style: String

var Exam1: Array
var Exam2: Array
var Exam3: Array

var GaugeIncr: String
var Total: float
var HiddenBranch: bool

var SongData: String
#endregion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func parse(path: String):
	var file := FileAccess.open(path, FileAccess.READ)
	var text: String = file.get_as_text()
	#region Titles
	#(?m) multiline
	var regex: RegEx = RegEx.new()
	var buffer
	
	#Title
	regex.compile("(?m)^TITLE:.*$")
	buffer = regex.search(text)
	if(buffer): Title = buffer.get_string()
	buffer = null
	
	#TitleJP
	regex.compile("(?m)^TITLEJA:.*$")
	buffer = regex.search(text)
	if(buffer): TitleJP = buffer.get_string()
	buffer = null
	
	#TitleEN
	regex.compile("(?m)^TITLEEN:.*$")
	buffer = regex.search(text)
	if(buffer): TitleEN = buffer.get_string()
	buffer = null
	
	#TitleCN
	regex.compile("(?m)^TITLECN:.*$")
	buffer = regex.search(text)
	if(buffer): TitleCN = buffer.get_string()
	buffer = null
	
	#TitleTW
	regex.compile("(?m)^TITLETW:.*$")
	buffer = regex.search(text)
	if(buffer): TitleTW = buffer.get_string()
	buffer = null
	
	#TitleKO
	regex.compile("(?m)^TITLEKO:.*$")
	buffer = regex.search(text)
	if(buffer): TitleKO = buffer.get_string()
	buffer = null
	#endregion
	
	print(Title)
	print(TitleJP)
	print(TitleEN)
	print(TitleCN)
	print(TitleTW)
	print(TitleKO)
	print("")
	print(Subtitle)
	print(SubtitleJP)
