extends Node

var game: Game
var course: String = "Edit"
var note = load("res://Themes/Default Theme/Game/note.tscn")
var gg_res = load("res://Themes/Default Theme/Game/gogo.tscn")

#These values can be changed by commands.
var _offset: float
var _bpm: float
var _chart: Game.Chart
var _scroll: float = 1
var _measure: float = 1
var _balloon_active: bool = false
var _roll_active: bool = false
var _total_notes: int = 0

var _score_p1: Score
var _score_p2: Score

var gogo: bool = false:
	set(value):
		if value:
			$Track.visible = false
		else:
			$Track.visible = true
		gogo = value

func _ready():
	#region Init
	game = Game.new(BackgroundData.active_song)
	_offset = game.offset
	_bpm = game.bpm
	#Title
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
	$Wave.connect("finished", on_song_finished)
	match course:
		"Edit":
			_chart = game.chart_oni
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
			var line: String = a.get_string(1)
			var buffer: RegExMatch
			if(line.begins_with("#")):
				if(line.begins_with("#MEASURE")):
					regex.compile(r'^#MEASURE (.*)\/(.*)$')
					buffer = regex.search(line)
					_measure = buffer.get_string(1).to_float() / buffer.get_string(2).to_float()
					print("MEASURE: ", _measure)
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
					var ggs: Node2D = gg_res.instantiate()
					ggs.speed = game.head_scroll * _scroll * 260 * 1.5
					ggs.position.x = 260 * (prev_time + -_offset) * (ggs.speed / 260)
					ggs.value = true
					add_child(ggs)
				
				elif(line.begins_with("#GOGOEND")):
					var gge: Node2D = gg_res.instantiate()
					gge.speed = game.head_scroll * _scroll * 260 * 1.5
					gge.position.x = 260 * (prev_time + -_offset) * (gge.speed / 260)
					gge.value = false
					add_child(gge)
				
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
			elif line == "":
				print("FLAG")
				prev_time += 60 * _measure * 4 / _bpm
			else:
				for n in range(0, line.length()):
					if(line[n] != "0" && line[n] != "8"):
						var new_note: Note = note.instantiate()
						new_note.type = line[n]
						new_note.speed = game.head_scroll * _scroll * 260 / 1.5
						new_note.position.x = 260 * (prev_time + -_offset) * (new_note.speed / 260)
						new_note.time = new_note.position.x / new_note.speed / 260
						new_note.score = _score_p1
						$Notes.add_child(new_note)
						$Notes.move_child(new_note, 0)
						_total_notes += 1
					elif(line[n] == "8"):
						_balloon_active = false
						_roll_active = false
					if(_balloon_active):
						pass
					prev_time += (60 * _measure * 4 / _bpm) / note_count
	print(BackgroundData.genre)
	match BackgroundData.genre.strip_edges():
		"ボーカロイド", "VOCALOID":
			var bg = load("res://Themes/Default Theme/Backgrounds/Vocaloid/vocaloid.tscn")
			$Background.add_child(bg.instantiate())
	_score_p1 = Score.new(_total_notes)

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("p1_don_left")):
		$"Taiko/Don Left".stop()
		$"Taiko/Don Left".play("play")
	if(event.is_action_pressed("p1_don_right")):
		$"Taiko/Don Right".stop()
		$"Taiko/Don Right".play("play")
	if(event.is_action_pressed("p1_ka_left")):
		$"Taiko/Ka Left".stop()
		$"Taiko/Ka Left".play("play")
	if(event.is_action_pressed("p1_ka_right")):
		$"Taiko/Ka Right".stop()
		$"Taiko/Ka Right".play("play")

var ended: bool = false
var song_ended: bool = false
func _process(_delta):
	if(_score_p1.combo >= 5):
		$Combo.visible = true
		$Combo.text = str(_score_p1.combo)
	else:
		$Combo.visible = false
	$Score.text = str(_score_p1.score)
	if(!ended && song_ended && $Notes.get_children().size() == 0):
		ended = true
		await get_tree().create_timer(1.0).timeout
		var main: Node2D = load("res://Themes/Default Theme/Song Select/song_select.tscn").instantiate()
		get_parent().add_child(main)
		self.queue_free()

func on_song_finished() -> void:
	song_ended = true
