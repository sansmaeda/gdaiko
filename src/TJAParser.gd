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

##Initial BPM of the song. Can be changed mid-song.
var BPM: float = 120
##Path to the song audio file used during gameplay. Located in the same folder as the TJA.
var Wave: String
##Offset of the notes in seconds.
var Offset: float 
##Offset of the title gameplay demonstration for the song
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
	if(buffer): Title = buffer.get_string().trim_prefix("TITLE:")
	buffer = null
	
	#TitleJP
	regex.compile("(?m)^TITLEJA:.*$")
	buffer = regex.search(text)
	if(buffer): TitleJP = buffer.get_string().trim_prefix("TITLEJA:")
	buffer = null
	
	#TitleEN
	regex.compile("(?m)^TITLEEN:.*$")
	buffer = regex.search(text)
	if(buffer): TitleEN = buffer.get_string().trim_prefix("TITLEEN:")
	buffer = null
	
	#TitleCN
	regex.compile("(?m)^TITLECN:.*$")
	buffer = regex.search(text)
	if(buffer): TitleCN = buffer.get_string().trim_prefix("TITLECN:")
	buffer = null
	
	#TitleTW
	regex.compile("(?m)^TITLETW:.*$")
	buffer = regex.search(text)
	if(buffer): TitleTW = buffer.get_string().trim_prefix("TITLETW:")
	buffer = null
	
	#TitleKO
	regex.compile("(?m)^TITLEKO:.*$")
	buffer = regex.search(text)
	if(buffer): TitleKO = buffer.get_string().trim_prefix("TITLEKO:")
	buffer = null
	#endregion
	
	#region Subtitles
	#Subtitle
	regex.compile("(?m)^SUBTITLE:.*$")
	buffer = regex.search(text)
	if(buffer): Subtitle = buffer.get_string().trim_prefix("SUBTITLE:")
	buffer = null
	
	#SubtitleJP
	regex.compile("(?m)^SUBTITLEJA:.*$")
	buffer = regex.search(text)
	if(buffer): SubtitleJP = buffer.get_string().trim_prefix("SUBTITLEJA:")
	buffer = null
	
	#SubtitleEN
	regex.compile("(?m)^SUBTITLEEN:.*$")
	buffer = regex.search(text)
	if(buffer): SubtitleEN = buffer.get_string().trim_prefix("SUBTITLEEN:")
	buffer = null
	
	#SubtitleCN
	regex.compile("(?m)^SUBTITLECN:.*$")
	buffer = regex.search(text)
	if(buffer): SubtitleCN = buffer.get_string().trim_prefix("SUBTITLECN:")
	buffer = null
	
	#SubtitleTW
	regex.compile("(?m)^SUBTITLETW:.*$")
	buffer = regex.search(text)
	if(buffer): SubtitleTW = buffer.get_string().trim_prefix("SUBTITLETW:")
	buffer = null
	
	#SubtitleKO
	regex.compile("(?m)^SUBTITLEKO:.*$")
	buffer = regex.search(text)
	if(buffer): SubtitleKO = buffer.get_string().trim_prefix("SUBTITLEKO:")
	buffer = null
	#endregion
	
	#BPM
	regex.compile("(?m)^BPM:.*$")
	buffer = regex.search(text)
	if(buffer): BPM = buffer.get_string().trim_prefix("BPM:").to_float()
	
	print(Title)
	print(TitleJP)
	print(TitleEN)
	print(TitleCN)
	print(TitleTW)
	print(TitleKO)
	print("")
	print(Subtitle)
	print(SubtitleJP)
	print(SubtitleEN)
	print(SubtitleCN)
	print(SubtitleTW)
	print(SubtitleKO)
	print("")
	print(BPM)
