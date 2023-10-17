extends CharacterBody2D

@onready var animation_player := $AnimationPlayer
@export var speed := 10
@export var max_speed := 300
@export var rotation_speed := 5
var rotation_direction := 0.0
var screen_size : Vector2
var rolled_four : bool

signal hit

func _ready():
	screen_size = get_viewport_rect().size

func get_input():
	# Get forward velocity and add to it every frame, speeds up on key hold, and limit speed
	velocity += Input.get_action_strength("forward") * -transform.y * speed
	velocity = velocity.limit_length(max_speed)
	
	if velocity.y == 0:
		animation_player.play("idle")
	elif Input.is_action_just_pressed("forward"):
		get_parent().engine.play()
		animation_player.play("flame_up")
	elif Input.is_action_just_released("forward"):
		get_parent().engine.stop()
		animation_player.play("flame_down")
	
	# Get rotation direction (outputs - or +)
	# If side-four is rolled, then invert controls
	if rolled_four:
		rotation_direction = Input.get_axis("turn_right", "turn_left")
	else:
		rotation_direction = Input.get_axis("turn_left", "turn_right")

func _process(delta):
	# Decelerates ship when forward key is no longer pressed
	velocity = velocity.move_toward(Vector2.ZERO, 3)
	
	get_input()
	
	rotation += rotation_direction * rotation_speed * delta
	move_and_collide(velocity * delta, false, 0.00)
	
	screen_wrap()

func screen_wrap():
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)

func _on_dice_rolled_four():
	rolled_four = true

func _on_dice_rolled_non_four():
	rolled_four = false

func _on_area_2d_body_entered(body):
	hit.emit()
	hide()
	collision_mask = 0
	collision_layer = 0
