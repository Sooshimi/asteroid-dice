extends Node

@export var laser_scene: PackedScene
@export var meteor_scene: PackedScene
@export var min_meteor_speed = 100.0
@export var max_meteor_speed = 200.0

var score

func _ready():
	new_game()

func _process(_delta):
	if $Player.is_visible_in_tree() && Input.is_action_pressed("shoot") && $ShootCooldownTimer.is_stopped():
		fire_laser()

func fire_laser():
	var laser = laser_scene.instantiate()
	laser.position = $Player.position
	laser.rotation = $Player.rotation
	add_child(laser)
	$ShootCooldownTimer.start()

func game_over():
	$ShootCooldownTimer.stop()
	$MeteorTimer.stop()

func new_game():
	score = 0
	$MeteorTimer.start()
	$Player.global_position = $StartPosition.position

func _on_meteor_timer_timeout():
	# Create new instance of meteor
	var meteor = meteor_scene.instantiate()
	
	# Get the MeteorSpawnLocation node
	var meteor_spawn_location = get_node("MeteorPath/MeteorSpawnLocation")
	
	# Set location of MeteorSpawnLocation node along MeteorPath
	meteor_spawn_location.progress_ratio = randf()
	
	# Set the direction of the meteor perpendicular to the path
	var direction = meteor_spawn_location.rotation + PI/2
	
	# Set meteor's position to the chosen random spawn location
	meteor.position = meteor_spawn_location.position
	
	# Add randomness to the meteor direction (within a conical range)
	direction += randf_range(-PI/4, PI/4)
	meteor.rotation = direction
	
	# Choose meteor velocity
	var velocity = Vector2(randf_range(min_meteor_speed, max_meteor_speed), 0.0)
	meteor.linear_velocity = velocity.rotated(direction)
	
	add_child(meteor)
