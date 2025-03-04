extends Node2D
class_name Note

## Speed of the note in pixels per second
var speed: float
## Type of the note:[br]
## 1: Don[br]
## 2: Ka[br]
## 3: Don (big)[br]
## 4: Ka (big)[br]
## 5: Drumroll[br]
## 6: Drumroll (big)[br]
## 7: Balloon[br]
## 8: End balloon/roll[br]
## 9: Kusudama[br]
## A: Don (both)[br]
## B: Ka (both)
var type: String
var roll_count: int
var time: float
var score: Score
var input: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match type:
		"1", "A":
			$Sprite2D.texture = load("res://Themes/Default Theme/Sprites/Notes/don.png")
			input = "don"
		"2", "B":
			$Sprite2D.texture = load("res://Themes/Default Theme/Sprites/Notes/ka.png")
			input = "ka"
		"3":
			$Sprite2D.texture = load("res://Themes/Default Theme/Sprites/Notes/dondai.png")
			input = "don"
		"4":
			$Sprite2D.texture = load("res://Themes/Default Theme/Sprites/Notes/kadai.png")
			input = "ka"
		"5":
			$Sprite2D.texture = load("res://Themes/Default Theme/Sprites/Notes/renda.png")
			input = "either"
		"6":
			$Sprite2D.texture = load("res://Themes/Default Theme/Sprites/Notes/rendadai.png")
			input = "either"
		"7":
			$Sprite2D.texture = load("res://Themes/Default Theme/Sprites/Notes/fuusen.png")
			input = "either"
		"8":
			pass
		"9":
			pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= speed * delta
	if get_parent().get_child(-1) == self && \
	match_input(input) && \
	abs(position.x) < speed * Game.RYOU:
		queue_free()
		$"../../"._score_p1.add(0, type)
	elif get_parent().get_child(-1) == self && \
	match_input(input) && \
	abs(position.x) < speed * Game.KA:
		queue_free()
		$"../../"._score_p1.add(1, type)
	elif position.x < -speed * Game.FUKA:
		queue_free()
		$"../../"._score_p1.add(2, type)
func match_input(input: String) -> bool:
	match input:
		"don":
			return Input.is_action_just_pressed("don_left") || Input.is_action_just_pressed("don_right")
		"ka":
			return Input.is_action_just_pressed("ka_left") || Input.is_action_just_pressed("ka_right")
		"either":
			return match_input("don") || match_input("ka")
		_:
			return false
