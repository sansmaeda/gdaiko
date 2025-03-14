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
var wave: String
##Offset of the notes in seconds.
var offset: float
##Offset of the title gameplay demonstration for the song
var demo_start: float

##Initial BPM of the song. Can be changed mid-song.
var bpm: float = 120
##Initial scrolling speed. #SCROLL in the chart is multiplied by this.
var head_scroll: float = 1
var score_mode: int = 1
##Volume multiplier for the music file
var song_vol: float = 100
##Ingame SFX volume multiplier
var se_vol: float = 100
##Replaces gauge if other than 0. Number of misses before failing the song.
var life: int = 0



##Chart creator
var maker: String
var side: String = "Normal" #Normal/1, EX/2, Both/3

var bg_image: String
var bg_movie: String
var movie_offset: float
#endregion

#region Course Variables
var chart_easy: Game.Chart
var chart_normal: Game.Chart
var chart_hard: Game.Chart
var chart_oni: Game.Chart
##Ura Oni chart
var chart_edit: Game.Chart
##???
var chart_tower: Game.Chart
##Dojo mode chart
var chart_dan: Game.Chart
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
		title = buffer.get_string(1).strip_escapes()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#TitleJP
	regex.compile(r'(?m)^TITLEJA:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		title_ja = buffer.get_string(1).strip_escapes()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#TitleEN
	regex.compile(r'(?m)^TITLEEN:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		title_en = buffer.get_string(1).strip_escapes()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	#endregion
	
	#region Subtitles
	#Subtitle
	regex.compile(r'(?m)^SUBTITLE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		subtitle = buffer.get_string(1).strip_escapes()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#SubtitleJP
	regex.compile(r'(?m)^SUBTITLEJA:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		subtitle_ja = buffer.get_string(1).strip_escapes()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#SubtitleEN
	regex.compile(r'(?m)^SUBTITLEEN:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		subtitle_en = buffer.get_string(1).strip_escapes()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	#endregion
	
	#BPM
	regex.compile(r'(?m)^BPM:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		bpm = buffer.get_string(1).strip_escapes().to_float()
	
	buffer = null
	
	#Wave
	regex.compile(r'(?m)^WAVE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		wave = buffer.get_string(1).strip_escapes()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Offset
	regex.compile(r'(?m)^OFFSET:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		offset = buffer.get_string(1).strip_escapes().to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#DemoStart
	regex.compile(r'(?m)^DEMOSTART:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		demo_start = buffer.get_string(1).strip_escapes().to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#ScoreMode
	regex.compile(r'(?m)^SCOREMODE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		score_mode = buffer.get_string(1).strip_escapes().to_int()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Maker
	regex.compile(r'(?m)^MAKER:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		maker = buffer.get_string(1).strip_escapes()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Lyrics
	#Not used
	
	#SongVol
	regex.compile(r'(?m)^SONGVOL:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		song_vol = buffer.get_string(1).strip_escapes().to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#SEVol
	regex.compile(r'(?m)^SEVOL:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		se_vol = buffer.get_string(1).strip_escapes().to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Side
	regex.compile(r'(?m)^SIDE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		side = buffer.get_string(1).strip_escapes()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#Life
	regex.compile(r'(?m)^LIFE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		life = buffer.get_string().strip_escapes().to_int()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#HeadScroll
	regex.compile(r'(?m)^HEADSCROLL:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		head_scroll = buffer.get_string(1).strip_escapes().to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#BGImage
	regex.compile(r'(?m)^BGIMAGE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		bg_image = buffer.get_string(1).strip_escapes()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#BGMovie
	regex.compile(r'(?m)^BGMOVIE:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		bg_movie = buffer.get_string(1).strip_escapes()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	
	#MovieOffset
	regex.compile(r'(?m)^MOVIEOFFSET:(.*)$')
	buffer = regex.search(text)
	if(buffer):
		movie_offset = buffer.get_string(1).strip_escapes().to_float()
		text = text.erase(buffer.get_start(), buffer.get_string().length()+1)
	buffer = null
	#endregion
	
	#region Charts
	regex.compile(r'(?sm)^.*?\n#END')
	for block in regex.search_all(text):
		var staging = block.get_string()
		var chart: Game.Chart = Game.Chart.new()
		
		#Level
		regex.compile(r'(?m)^LEVEL:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.level = buffer.get_string(1).strip_escapes().to_int()
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#Balloon
		regex.compile(r'(?m)^BALLOON:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			regex.compile(r'(.+?)(?:,\s*|\z)')
			var temp: Array = []
			for i in regex.search_all(buffer.get_string(1)):
				temp.append(i.get_string().strip_escapes().to_int())
			chart.balloon = temp
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#BALLOONNOR:, BALLOONEXP:, BALLOONMAS: (?)
		
		#ScoreInit
		regex.compile(r'(?m)^SCOREINIT:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.score_init = buffer.get_string(1).strip_escapes().to_int()
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#ScoreDiff
		regex.compile(r'(?m)^SCOREDIFF:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.score_diff = buffer.get_string(1).strip_escapes().to_int()
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#Style
		regex.compile(r'(?m)^STYLE:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.style = buffer.get_string(1).strip_escapes()
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
				temp.append(i.get_string().strip_escapes())
			chart.exam1 = temp
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#Exam2
		regex.compile(r'(?m)^EXAM2:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			regex.compile(REGEX_ARRAY)
			var temp: Array = []
			for i in regex.search_all(buffer.get_string(1)):
				temp.append(i.get_string().strip_escapes())
			chart.exam2 = temp
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#Exam3
		regex.compile(r'(?m)^EXAM3:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			regex.compile(REGEX_ARRAY)
			var temp: Array = []
			for i in regex.search_all(buffer.get_string(1)):
				temp.append(i.get_string().strip_escapes())
			chart.exam3 = temp
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		#endregion
		
		#GaugeIncr
		regex.compile(r'(?m)^GAUGEINCR:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.gauge_incr = buffer.get_string(1).strip_escapes()
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#Total
		regex.compile(r'(?m)^TOTAL:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.total = buffer.get_string(1).strip_escapes()
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#HiddenBranch
		regex.compile(r'(?m)^HIDDENBRANCH:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.hidden_branch = buffer.get_string(1).strip_escapes() == "1"
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#ChartData
		regex.compile(r'(?ms)^(#START.*#END)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.data = buffer.get_string(1).strip_edges()
			staging = staging.erase(buffer.get_start(), buffer.get_string().length()+1)
		buffer = null
		
		#Chart
		regex.compile(r'(?m)^COURSE:(.*)$')
		buffer = regex.search(staging)
		if(buffer):
			chart.course = buffer.get_string(1).strip_escapes()
		else:
			chart.course = "Oni"
		match chart.course:
			"Easy", "0":
				chart_easy = chart
			"Normal", "1":
				chart_normal = chart
			"Hard", "2":
				chart_hard = chart
			"Oni", "3":
				chart_oni = chart
			"Edit", "4", "Ura":
				chart_edit = chart
			"Tower", "5":
				chart_tower = chart
			"Dan", "6":
				chart_dan = chart
		buffer = null
	#endregion
