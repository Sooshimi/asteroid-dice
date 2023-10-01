extends CharacterBody2D

@export var speed = 10
@export var max_speed = 300
@export var rotation_speed = 5
var rotation_direction = 0
var screen_size

signal hit

# Get input vector to decelerate ship when vector's y is 0
var input_vector = Vector2(0, Input.get_action_strength("forward"))

func _ready():
	screen_size = get_viewport_rect().size

func get_input():
	# Get forward velocity and add to it every frame, speeds up on key hold, and limit speed
	velocity += Input.get_action_strength("forward") * -transform.y * speed
	velocity = velocity.limit_length(max_speed)
	
	# Get rotation direction (outputs - or +)
	rotation_direction = Input.get_axis("turn_left", "turn_right")

func _process(delta):
	# Decelerates ship when forward key is no longer pressed
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	var collision = move_and_collide(velocity * delta, false, 0.00)
	
	# If player hits something, destroy it
	if collision:
		hit.emit()
		hide()
	
	screen_wrap()

func screen_wrap():
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)
	
