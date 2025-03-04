extends RefCounted
class_name Score
##Tracks the score based on a set of notes.

var total_notes: int

var score: int = 0
var combo: int = 0
var score_mode: int
var init: int
var diff: int

func _init(total_notes: int):
	self.total_notes = total_notes

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
	score += 1000000 / float(total_notes) * mult
