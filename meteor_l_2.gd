extends RigidBody2D

@export var hp := 1

func _ready():
	pass

func _process(delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
