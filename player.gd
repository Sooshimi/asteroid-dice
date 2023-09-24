extends CharacterBody2D

@export var speed = 300
@export var turn_speed = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("forward"):
		velocity.y -= 1
	if Input.is_action_pressed("turn_left"):
		rotate(deg_to_rad(-turn_speed * delta))
	if Input.is_action_pressed("turn_right"):
		rotate(deg_to_rad(turn_speed * delta))
	
	if velocity.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	
	position += velocity.rotated(rotation) * speed * delta
	
