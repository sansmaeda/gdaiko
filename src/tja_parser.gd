class_name TJAParser
extends RefCounted
## Parses a .tja chart file into accessible data points
##
## @tutorial: https://iepiweidieng.github.io/TJAPlayer3/tja/
## @tutorial: https://github.com/269Seahorse/Better-taiko-web/blob/master/TJA-format.mediawiki
## @tutorial: https://outfox.wiki/en/dev/mode-support/tja-support

const REGEX_ARRAY: String = r'(.+?)\s*(?:,\s*|\z)'

#region Song Metadata Variables
##Title of the song. (Default)
var title: String
##Title of the song. (Japanese)
var title_ja: String
##Title of the song. (English)
var title_en: String

##Subtitle of the song. Shown under the title in the song selector.
var subtitle: String
##Japanese subtitle
var subtitle_ja: String
##English subtitle
var subtitle_en: String

##Path to the song audio file used during gameplay. Located in the same folder as the TJA.
var Wave: String
##Offset of the notes in seconds.
var Offset: float
##Offset of the title gameplay demonstration for the song
var DemoStart: float

##Initial BPM of the song. Can be changed mid-song.
var BPM: float = 120
##Initial scrolling speed. #SCROLL in the chart is multiplied by this.
var HeadScroll: float = 1
var ScoreMode: int = 1
##Volume multiplier for the music file
var SongVol: float = 100
##Ingame SFX volume multiplier
var SEVol: float = 100
##Replaces gauge if other than 0. Number of misses before failing the song.
var Life: int = 0

##Genre of the song. Determines which folder the song appears in.
var Genre: String
##Chart creator
var Maker: String
var Side: String = "Normal" #Normal/1, EX/2, Both/3

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
var ChartNormal: Chart
var ChartHard: Chart
var ChartOni: Chart
##Ura Oni chart
var ChartEdit: Chart
##???
var ChartTower: Chart
##Dojo mode chart
var ChartDan: Chart
#endregion

##Loads the data from a tja file
func parse(path: String):
	var file := FileAccess.open(path, FileAccess.READ)
	var text: String = file.get_as_text()
	#(?m) regex multiline flag
	var regex: RegEx = RegEx.new()
	var buffer
	
	#region Cleaning
	#Remove comments
	regex.compile(r'(?m)\/\/.*$')
	while(true):
		buffer = regex.search(text)
		if(buffer):
			text = text.erase(max(buffer.get_start()-1, 0), buffer.get_end()-buffer.get_start()+1)
			buffer = null
		else:
			buffer = null
			break
	
	#Remove blank lines
	regex.compile(r'(?m)^\s+')
	while(true):
		buffer = regex.search(text)
		if(buffer):
			text = text.erase(max(buffer.get_start()-1, 0), buffer.get_end()-buffer.get_start())
			buffer = null
		else:
			buffer = null
			break
	#endregion
	
	#region Song Metadata
	#region Titles
	#Title
	regex.compile(r'(?m)^TITLE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		title = buffer.get_string(1)
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#TitleJP
	regex.compile(r'(?m)^TITLEJA:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		title_ja = buffer.get_string(1)
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#TitleEN
	regex.compile(r'(?m)^TITLEEN:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		title_en = buffer.get_string(1)
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	#endregion
	
	#region Subtitles
	#Subtitle
	regex.compile(r'(?m)^SUBTITLE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		subtitle = buffer.get_string(1)
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#SubtitleJP
	regex.compile(r'(?m)^SUBTITLEJA:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		subtitle_ja = buffer.get_string(1)
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#SubtitleEN
	regex.compile(r'(?m)^SUBTITLEEN:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		subtitle_en = buffer.get_string(1)
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	#endregion
	
	#BPM
	regex.compile(r'(?m)^BPM:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		BPM = buffer.get_string(1).to_float()
	
	buffer = null
	
	#Wave
	regex.compile(r'(?m)^WAVE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		Wave = buffer.get_string(1)
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Offset
	regex.compile(r'(?m)^OFFSET:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		Offset = buffer.get_string(1).to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#DemoStart
	regex.compile(r'(?m)^DEMOSTART:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		DemoStart = buffer.get_string(1).to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Genre
	regex.compile(r'(?m)^GENRE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		Genre = buffer.get_string(1)
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#ScoreMode
	regex.compile(r'(?m)^SCOREMODE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		ScoreMode = buffer.get_string(1).to_int()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Maker
	regex.compile(r'(?m)^MAKER:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		Maker = buffer.get_string(1)
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Lyrics
	#Not used
	
	#SongVol
	regex.compile(r'(?m)^SONGVOL:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		SongVol = buffer.get_string(1).to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#SEVol
	regex.compile(r'(?m)^SEVOL:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		SEVol = buffer.get_string(1).to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Side
	regex.compile(r'(?m)^SIDE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		Side = buffer.get_string(1)
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Life
	regex.compile(r'(?m)^LIFE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		Life = buffer.get_string().to_int()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#HeadScroll
	regex.compile(r'(?m)^HEADSCROLL:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		HeadScroll = buffer.get_string(1).to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#BGImage
	regex.compile(r'(?m)^BGIMAGE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		BGImage = buffer.get_string(1)
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#BGMovie
	regex.compile(r'(?m)^BGMOVIE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		BGMovie = buffer.get_string(1)
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#MovieOffset
	regex.compile(r'(?m)^MOVIEOFFSET:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		MovieOffset = buffer.get_string(1).to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	#endregion
	
	#region Charts
	regex.compile(r'(?sm)^.*?\n#END')
	for block in regex.search_all(text):
		var staging = block.get_string()
		var chart: Chart = Chart.new()
		
		#Level
		regex.compile(r'(?m)^LEVEL:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.Level = buffer.get_string(1).to_int()
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#Balloon
		regex.compile(r'(?m)^BALLOON:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			regex.compile(r'(.+?)(?:,\s*|\z)')
			var temp: Array = []
			for i in regex.search_all(buffer.get_string(1)):
				temp.append(i.get_string().to_int())
			chart.Balloon = temp
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#BALLOONNOR:, BALLOONEXP:, BALLOONMAS: (?)
		
		#ScoreInit
		regex.compile(r'(?m)^SCOREINIT:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.ScoreInit = buffer.get_string(1).to_int()
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#ScoreDiff
		regex.compile(r'(?m)^SCOREDIFF:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.ScoreDiff = buffer.get_string(1).to_int()
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
				
		#Style
		regex.compile(r'(?m)^STYLE:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.Style = buffer.get_string(1)
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#region Exams
		#Exam1
		regex.compile(r'(?m)^EXAM1:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			regex.compile(REGEX_ARRAY)
			var temp: Array = []
			for i in regex.search_all(buffer.get_string(1)):
				temp.append(i.get_string())
			chart.Exam1 = temp
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#Exam2
		regex.compile(r'(?m)^EXAM2:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			regex.compile(REGEX_ARRAY)
			var temp: Array = []
			for i in regex.search_all(buffer.get_string(1)):
				temp.append(i.get_string())
			chart.Exam2 = temp
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#Exam3
		regex.compile(r'(?m)^EXAM3:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			regex.compile(REGEX_ARRAY)
			var temp: Array = []
			for i in regex.search_all(buffer.get_string(1)):
				temp.append(i.get_string())
			chart.Exam3 = temp
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		#endregion
		
		#GaugeIncr
		regex.compile(r'(?m)^GAUGEINCR:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.GaugeIncr = buffer.get_string(1)
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#Total
		regex.compile(r'(?m)^TOTAL:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.Total = buffer.get_string(1)
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#HiddenBranch
		regex.compile(r'(?m)^HIDDENBRANCH:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.HiddenBranch = buffer.get_string(1) == "1"
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#ChartData
		regex.compile(r'(?ms)^(#START.*#END)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.ChartData = buffer.get_string(1)
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#Chart
		regex.compile(r'(?m)^COURSE:(.*)$')
		buffer = regex.search(staging)
		chart.Course = buffer.get_string(1).strip_edges()
		match chart.Course:
			"Easy", "0":
				ChartEasy = chart
			"Normal", "1":
				ChartNormal = chart
			"Hard", "2":
				ChartHard = chart
			"Oni", "3":
				ChartOni = chart
			"Edit", "4", "Ura":
				ChartEdit = chart
			"Tower", "5":
				ChartTower = chart
			"Dan", "6":
				ChartDan = chart
		buffer = null
	#endregion

func print():
	print("SONG DATA")
	print("TITLE: ", title)
	print("TITLEJP: ", title_ja)
	print("TITLEEN: ", title_en)
	print("")
	print("SUBTITLE: ", subtitle)
	print("SUBTITLEJP: ", subtitle_ja)
	print("SUBTITLEEN: ", subtitle_en)
	print("")
	print("BPM: ", BPM)
	print("WAVE: ", Wave)
	print("OFFSET: ", Offset)
	print("DEMOSTART: ", DemoStart)
	print("")
	print("GENRE: ", Genre)
	print("SCOREMODE: ", ScoreMode)
	print("MAKER: ", Maker)
	print("SONGVOL: ", SongVol)
	print("SEVOL: ", SEVol)
	print("SIDE: ", Side)
	print("LIFE: ", Life)
	print("HEADSCROLL: ", HeadScroll)
	print("BGIMAGE: ", BGImage)
	print("BGMOVIE: ", BGMovie)
	print("MOVIEOFFSET: ", MovieOffset)
	print("")
	if(ChartEdit != null):
		print("CHARTEDIT FOUND")
		print("LEVEL: ", ChartEdit.Level)
		print("BALLOON: ", ChartEdit.Balloon)
		print("SCOREINIT: ", ChartEdit.ScoreInit)
		print("SCOREDIFF: ", ChartEdit.ScoreDiff)
		print("STYLE: ", ChartEdit.Style)
		print("EXAM1: ", ChartEdit.Exam1)
		print("EXAM2: ", ChartEdit.Exam2)
		print("EXAM3: ", ChartEdit.Exam3)
		print("GAUGEINCR: ", ChartEdit.GaugeIncr)
		print("TOTAL: ", ChartEdit.Total)
		print("HIDDENBRANCH: ", ChartEdit.HiddenBranch)
		print("DATA: \n", ChartEdit.ChartData)
