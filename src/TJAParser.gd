# https://github.com/269Seahorse/Better-taiko-web/blob/master/TJA-format.mediawiki
# https://outfox.wiki/en/dev/mode-support/tja-support
class_name TJAParser
extends RefCounted
##Parses a .tja chart file into accessible data points

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

##Subtitle of the song. Shown under the title in the song selector.
var Subtitle: String
##Japanese subtitle
var SubtitleJP: String
##English subtitle
var SubtitleEN: String
##Chinese subtitle
var SubtitleCN: String
##Traditional Chinese subtitle
var SubtitleTW: String
##Korean subtitle
var SubtitleKO: String

##Initial BPM of the song. Can be changed mid-song.
var BPM: float = 120
##Path to the song audio file used during gameplay. Located in the same folder as the TJA.
var Wave: String
##Offset of the notes in seconds.
var Offset: float 
##Offset of the title gameplay demonstration for the song
var DemoStart: float

##Genre of the song. Determines which folder the song appears in.
var Genre: String
var ScoreMode: int = 1
##Chart creator
var Maker: String
#Not used
#var Lyrics: String
##Volume multiplier for the music file
var SongVol: float = 100
##Ingame SFX volume multiplier
var SEVol: float = 100
var Side: String #???
##Replaces gauge if other than 0. Number of misses before failing the song.
var Life: int = 0
var Game: String = "Taiko" #?
##Initial scrolling speed. #SCROLL in the chart is multiplied by this.
var HeadScroll: float = 1

var BGImage: String
var BGMovie: String
var MovieOffset: float
#endregion

#region Course Variables
##Class containing data used by an individual chart
class Chart:
	
	##Difficulty of the chart. (EG. Oni)
	var Course: String
	##Number of stars 
	var Level: int
	
	##Array containing balloon int values
	var Balloon: Array
	var BalloonNor: Array
	var BalloonExp: Array
	var BalloonMas: Array
	
	##Used for score calculation
	var ScoreInit: int
	var ScoreDiff: int
	var Style: String
	
	##Dojo bars
	var Exam1: Array
	var Exam2: Array
	var Exam3: Array
	
	##Rounding method for gauge
	var GaugeIncr: String
	##Percentage multiplier for notes effectiveness in gauge
	var Total: float
	var HiddenBranch: bool
	
	##Contains the actual data of the chart
	var ChartData: String

var ChartEasy: Chart
var ChartNornal: Chart
var ChartHard: Chart
var ChartOni: Chart
##Ura Oni chart
var ChartEdit: Chart
##???
var ChartTower: Chart 
##Dojo mode chart
var ChartDan: Chart
#endregion

func parse(path: String):
	var file := FileAccess.open(path, FileAccess.READ)
	var text: String = file.get_as_text()
	#(?m) regex multiline flag
	var regex: RegEx = RegEx.new()
	var buffer
	#Remove comments
	regex.compile(r'(?m)^//.*\n')
	buffer = regex.search_all(text)
	for item: RegExMatch in buffer:
		text = text.erase(item.get_start(), item.get_string().length()+1)
	
	#Remove blank lines
	regex.compile(r'(?m)^\n')
	buffer = regex.search_all(text)
	for item: RegExMatch in buffer:
		text = text.erase(item.get_start(), 1)
	text = text.strip_edges()
	
	#region Song Metadata
	#region Titles
	#Title
	regex.compile(r'(?m)^TITLE:.*$')
	buffer = regex.search(text)
	if(buffer): 
		Title = buffer.get_string().trim_prefix("TITLE:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#TitleJP
	regex.compile(r'(?m)^TITLEJA:.*$')
	buffer = regex.search(text)
	if(buffer): 
		TitleJP = buffer.get_string().trim_prefix("TITLEJA:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#TitleEN
	regex.compile(r'(?m)^TITLEEN:.*$')
	buffer = regex.search(text)
	if(buffer): 
		TitleEN = buffer.get_string().trim_prefix("TITLEEN:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#TitleCN
	regex.compile(r'(?m)^TITLECN:.*$')
	buffer = regex.search(text)
	if(buffer): 
		TitleCN = buffer.get_string().trim_prefix("TITLECN:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#TitleTW
	regex.compile(r'(?m)^TITLETW:.*$')
	buffer = regex.search(text)
	if(buffer): 
		TitleTW = buffer.get_string().trim_prefix("TITLETW:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#TitleKO
	regex.compile(r'(?m)^TITLEKO:.*$')
	buffer = regex.search(text)
	if(buffer): 
		TitleKO = buffer.get_string().trim_prefix("TITLEKO:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	#endregion
	
	#region Subtitles
	#Subtitle
	regex.compile(r'(?m)^SUBTITLE:.*$')
	buffer = regex.search(text)
	if(buffer): 
		Subtitle = buffer.get_string().trim_prefix("SUBTITLE:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#SubtitleJP
	regex.compile(r'(?m)^SUBTITLEJA:.*$')
	buffer = regex.search(text)
	if(buffer): 
		SubtitleJP = buffer.get_string().trim_prefix("SUBTITLEJA:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#SubtitleEN
	regex.compile(r'(?m)^SUBTITLEEN:.*$')
	buffer = regex.search(text)
	if(buffer): 
		SubtitleEN = buffer.get_string().trim_prefix("SUBTITLEEN:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#SubtitleCN
	regex.compile(r'(?m)^SUBTITLECN:.*$')
	buffer = regex.search(text)
	if(buffer): 
		SubtitleCN = buffer.get_string().trim_prefix("SUBTITLECN:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#SubtitleTW
	regex.compile(r'(?m)^SUBTITLETW:.*$')
	buffer = regex.search(text)
	if(buffer): 
		SubtitleTW = buffer.get_string().trim_prefix("SUBTITLETW:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#SubtitleKO
	regex.compile(r'(?m)^SUBTITLEKO:.*$')
	buffer = regex.search(text)
	if(buffer): 
		SubtitleKO = buffer.get_string().trim_prefix("SUBTITLEKO:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	#endregion
	
	#BPM
	regex.compile(r'(?m)^BPM:.*$')
	buffer = regex.search(text)
	if(buffer): 
		BPM = buffer.get_string().trim_prefix("BPM:").to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Wave
	regex.compile(r'(?m)^WAVE:.*$')
	buffer = regex.search(text)
	if(buffer): 
		Wave = buffer.get_string().trim_prefix("WAVE:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Offset
	regex.compile(r'(?m)^OFFSET:.*$')
	buffer = regex.search(text)
	if(buffer): 
		Offset = buffer.get_string().trim_prefix("OFFSET:").to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#DemoStart
	regex.compile(r'(?m)^DEMOSTART:.*$')
	buffer = regex.search(text)
	if(buffer): 
		DemoStart = buffer.get_string().trim_prefix("DEMOSTART:").to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Genre
	regex.compile(r'(?m)^GENRE:.*$')
	buffer = regex.search(text)
	if(buffer): 
		Genre = buffer.get_string().trim_prefix("GENRE:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#ScoreMode
	regex.compile(r'(?m)^SCOREMODE:.*$')
	buffer = regex.search(text)
	if(buffer): 
		ScoreMode = buffer.get_string().trim_prefix("SCOREMODE:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Maker
	regex.compile(r'(?m)^MAKER:.*$')
	buffer = regex.search(text)
	if(buffer): 
		Maker = buffer.get_string().trim_prefix("MAKER:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Lyrics
	#Not used
	
	#SongVol
	regex.compile(r'(?m)^SONGVOL:.*$')
	buffer = regex.search(text)
	if(buffer): 
		SongVol = buffer.get_string().trim_prefix("SONGVOL:").to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#SEVol
	regex.compile(r'(?m)^SEVOL:.*$')
	buffer = regex.search(text)
	if(buffer): 
		SEVol = buffer.get_string().trim_prefix("SEVOL:").to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Side
	regex.compile(r'(?m)^SIDE:.*$')
	buffer = regex.search(text)
	if(buffer): 
		Side = buffer.get_string().trim_prefix("SIDE:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Life
	regex.compile(r'(?m)^LIFE:.*$')
	buffer = regex.search(text)
	if(buffer): 
		Life = buffer.get_string().trim_prefix("LIFE:").to_int()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Game
	regex.compile(r'(?m)^GAME:.*$')
	buffer = regex.search(text)
	if(buffer): 
		Game = buffer.get_string().trim_prefix("GAME:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#HeadScroll
	regex.compile(r'(?m)^HEADSCROLL:.*$')
	buffer = regex.search(text)
	if(buffer): 
		HeadScroll = buffer.get_string().trim_prefix("HEADSCROLL:").to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#BGImage
	regex.compile(r'(?m)^BGIMAGE:.*$')
	buffer = regex.search(text)
	if(buffer): 
		BGImage = buffer.get_string().trim_prefix("BGIMAGE:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#BGMovie
	regex.compile(r'(?m)^BGMOVIE:.*$')
	buffer = regex.search(text)
	if(buffer): 
		BGMovie = buffer.get_string().trim_prefix("BGMOVIE:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#MovieOffset
	regex.compile(r'(?m)^MOVIEOFFSET:.*$')
	buffer = regex.search(text)
	if(buffer): 
		MovieOffset = buffer.get_string().trim_prefix("MOVIEOFFSET:")
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	#endregion
	
	#region Charts
	#region 0: Easy
	#endregion
	#region 1: Normal
	#endregion
	#region 2: Hard
	#endregion
	#region 3: Oni
	#endregion
	#endregion
	print("|"+text+"|")
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
	print(Wave)
	print(Offset)
	print(DemoStart)
	print("")
