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

func add(quality: int):
	match quality:
		0,1:
			combo += 1
		2:
			combo = 0
	match score_mode:
		1:
			score += init + min(10, floor(combo/10.0))
		3: 
			score += init * int(quality==0)
	#print("Hit ", quality, " Combo ", combo)
