extends CharacterBody2D

@export var laser_scene: PackedScene
@export var speed = 10
@export var max_speed = 300
@export var rotation_speed = 5
var rotation_direction = 0

# Get input vector to decelerate ship when vector's y is 0
var input_vector = Vector2(0, Input.get_axis("", "forward"))

func _ready():
	pass # Replace with function body.

func get_input():
	
	# Get forward velocity and add to it every frame, speeds up on key hold, and limit speed
	velocity += Input.get_axis("", "forward") * -transform.y * speed
	velocity = velocity.limit_length(max_speed)

	# Get rotation direction (outputs - or +)
	rotation_direction = Input.get_axis("turn_left", "turn_right")
	
	# Instantiate and create laser when shoot button is clicked
	if Input.is_action_pressed("shoot"):
		var laser = laser_scene.instantiate()
		add_child(laser)
	
func _process(delta):
	# Decelerates ship when forward key is no longer pressed
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	
	get_input()
	rotation += rotation_direction * rotation_speed * delta
	move_and_slide()
