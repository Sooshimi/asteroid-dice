extends Area2D

@export var speed = 1000
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.y -= 1
	global_position += velocity.rotated(rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
