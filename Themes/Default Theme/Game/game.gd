extends Node
var title: String
var game: Game = Game.new("res://Songs/Test Song/TestSong.tja")
var course: String = "Edit"
var note = load("res://Themes/Default Theme/note.tscn")

var _offset: float
var _bpm: float
var _chart: Game.Chart
var _scroll: float = 1
var _measure: float = 1
var _balloon_active: bool = false
var _roll_active: bool = false

var _score_p1: Score
var _score_p2: Score

# Called when the node enters the scene tree for the first time.
func _ready():
	#region Init
	add_child(game)
	_score_p1 = Score.new(game.score_mode, game.chart_edit.score_init, game.chart_edit.score_diff)
	_score_p2 = Score.new(game.score_mode, game.chart_edit.score_init, game.chart_edit.score_diff)
	_offset = game.offset
	_bpm = game.bpm
	print(_bpm)
	print(-_offset)
	if(TranslationServer.get_locale() == "ja" && game.title_ja != ""):
		$Title.text = game.title_ja
	elif(TranslationServer.get_locale() == "en" && game.title_en != ""):
		$Title.text = game.title_en
	else:
		$Title.text = game.title
	
	if(game.wave.ends_with(".ogg")):
		$"Wave".stream = AudioStreamOggVorbis.load_from_file(game.path.get_base_dir().path_join(game.wave))
	#TODO Support .wav and .mp3
	elif(game.wave.ends_with(".wav")):
		pass
	elif(game.wave.ends_with(".mp3")):
		pass
	$Wave.play()
	match course:
		"Edit":
			_chart = game.chart_edit
	#print(_chart.data)
	#endregion
	#Get measure (can contaim multiple lines)
	var regex = RegEx.create_from_string(r'(?ms)^(.*?),[\n\r]*') #(?m)^([^,\r\n]*)
	var prev_time: float = 0
	for i: RegExMatch in regex.search_all(_chart.data):
		var blob: String = i.get_string(1).strip_edges()
		var note_count: int = 0
		
		#Get note count in measure
		#Ignore lines starting with #
		regex.compile(r'(?m)^([^,\r\n]*)')
		var b: Array[RegExMatch] = regex.search_all(blob)
		for a: RegExMatch in b:
			var line: String = a.get_string(1).strip_edges()
			if(!line.begins_with("#")):
				note_count += line.length()
		for a: RegExMatch in b:
			var line: String = a.get_string(1).strip_edges()
			var buffer: RegExMatch
			if(line.begins_with("#")):
				if(line.begins_with("")):
					pass
				elif(line.begins_with("#START")):
					pass
				elif(line.begins_with("#END")):
					pass
				elif(line.begins_with("#LYRIC")):
					pass
				
				elif(line.begins_with("#MEASURE")):
					regex.compile(r'^#MEASURE (.*)\/(.*)$')
					buffer = regex.search(line)
					_measure = buffer.get_string(1).to_float() / buffer.get_string(2).to_float()
					buffer = null
				
				elif(line.begins_with("#BPMCHANGE ")):
					regex.compile("^#BPMCHANGE (.*)$")
					buffer = regex.search(line)
					_bpm = buffer.get_string(1).to_float()
					print("BPM CHANGE: ",_bpm)
					buffer = null
					
				elif(line.begins_with("#DELAY")):
					regex.compile("^#BPMCHANGE (.*)$")
					buffer = regex.search(line)
					prev_time += buffer.get_string(1).to_float()
					print("DELAY: ", prev_time)
					buffer = null
				
				elif(line.begins_with("#SCROLL")):
					regex.compile("^#SCROLL (.*)$")
					buffer = regex.search(line)
					_scroll = buffer.get_string(1).to_float()
					print("SCROLL: ", _scroll)
					buffer = null
				
				elif(line.begins_with("#GOGOSTART")):
					pass
				elif(line.begins_with("#GOGOEND")):
					pass
				elif(line.begins_with("#BARLINEOFF")):
					pass
				elif(line.begins_with("#BARLINEON")):
					pass
				elif(line.begins_with("#BRANCHSTART")):
					pass
				elif(line.begins_with("#SECTION")):
					pass
				elif(line.begins_with("#LEVELHOLD")):
					pass
				elif(line.begins_with("#SENOTECHANGE")):
					pass
				elif(line.begins_with("#NEXTSONG")):
					pass
			else:
				print(line)
				var measure_total = 60 * _measure * 4 / _bpm
				for n in range(0, line.length()):
					if(line[n] != "0" && line[n] != "8"):
						var new_note: Note = note.instantiate()
						new_note.type = line[n]
						new_note.speed = game.head_scroll * _scroll * 260
						new_note.position.x = 260 * (prev_time + -_offset) * (new_note.speed / 260)
						#pos = start + speed * time
						#0 = start + speed * time
						#time = start / speed
						new_note.time = new_note.position.x / new_note.speed / 260
						new_note.score = _score_p1
						$Notes.add_child(new_note)
						$Notes.move_child(new_note, 0)
					elif(line[n] == "8"):
						_balloon_active = false
						_roll_active = false
					if(_balloon_active):
						pass
					prev_time += measure_total / note_count
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Combo.text = str(_score_p1.combo)
	$Score.text = str(_score_p1.score)
