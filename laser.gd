extends Area2D

@export var speed = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	velocity.y -= 1
	position += velocity * speed * delta
