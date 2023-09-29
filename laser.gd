extends Area2D

@export var speed = 1000
var vector = Vector2.ZERO

signal laser_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	vector.y -= 1
	global_position += vector.rotated(rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	print("hitbody")
	laser_hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()
