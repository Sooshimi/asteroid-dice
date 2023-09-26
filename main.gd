extends Node

@export var laser_scene: PackedScene
@export var laser_speed = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fire_laser():
	var laser = laser_scene.instantiate()
	laser.position = $Player.position
	laser.rotation = $Player.rotation
	add_child(laser)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Instantiate and create laser when shoot button is clicked
	if Input.is_action_pressed("shoot"):
		fire_laser()
