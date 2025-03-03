extends RefCounted
class_name Score
##Tracks the score based on a set of notes.

var score: int = 0
var combo: int = 0
var score_mode: int
var init: int
var diff: int

func _init(score_mode: int, init: int, diff: int):
	self.score_mode = score_mode
	self.init = init
	self.diff = diff

func add(quality: int, type: String):
	var mult: float
	#Multiplier
	match quality:
		2: mult = 0
		1: mult = 0.5
		0: mult = 1
	#Combo
	match quality:
		0,1:
			combo += 1
		2:
			combo = 0
	#Apply score
	match score_mode:
		1:
			score += init + min(10, floor(combo/10.0))
		3: 
			if(combo >= 100):
				score += (init + diff * 8) * mult
			elif(combo >= 50):
				score += (init + diff * 4) * mult
			elif(combo >= 30):
				score += (init + diff * 2) * mult
			elif(combo >= 10):
				score += (init + diff * 1) * mult
			else:
				score += (init) * mult
