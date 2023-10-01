extends Area2D

@export var speed = 200
var vector = Vector2.ZERO
var score

func _ready():
	pass

func _process(delta):
	vector.y -= 1
	position += vector.rotated(rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	queue_free()

	if body.name == "Dice":
		body.roll()
	else:
		body.hp -= 1
		if body.hp == 0:
			get_parent().score += 1
			get_parent().get_node("HUD").update_score(get_parent().score)
			body.queue_free()
