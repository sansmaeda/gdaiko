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
## 9: Kusudama[br]
## A: Don (both)[br]
## B: Ka (both)
var type: String
#
#func _init(type: String, speed: float):
	#self.type = type
	#self.speed = speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match type:
		"1":
			$Sprite2D.texture = load("res://Themes/Default Theme/Sprites/Notes/don.png")
		"2":
			$Sprite2D.texture = load("res://Themes/Default Theme/Sprites/Notes/ka.png")
		"3":
			$Sprite2D.texture = load("res://Themes/Default Theme/Sprites/Notes/dondai.png")
		"4":
			$Sprite2D.texture = load("res://Themes/Default Theme/Sprites/Notes/kadai.png")
		"5":
			$Sprite2D.texture = load("res://Themes/Default Theme/Sprites/Notes/renda.png")
		"6":
			$Sprite2D.texture = load("res://Themes/Default Theme/Sprites/Notes/rendadai.png")
		"7":
			$Sprite2D.texture = load("res://Themes/Default Theme/Sprites/Notes/fuusen.png")
		"8":
			pass
		"9":
			pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= speed * delta
