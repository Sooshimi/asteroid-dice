extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	var rotated = Vector2.from_angle(0)
	
	if Input.is_action_pressed("forward"):
		velocity.y += 1
	
	
