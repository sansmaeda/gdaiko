extends Node2D
var speed: float
var value: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta: float) -> void:
	position.x -= speed * delta
	if(position.x <= 0):
		get_parent().gogo = value
		self.queue_free()
