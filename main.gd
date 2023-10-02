extends Node

@export var laser_scene: PackedScene
@export var meteor_scene: PackedScene
@export var min_meteor_speed = 100.0
@export var max_meteor_speed = 200.0

var score

# Initial meteor rotation speed and velocity on game start
var multiple_meteor_rotation_speed = 1
var multiply_meteor_velocity = 1

func _ready():
	new_game()
	$HUD.hide_new_game_button()

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
	$HUD.show_new_game_button()
	$ShootCooldownTimer.stop()
	$MeteorTimer.stop()

func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.hide_new_game_button()
	get_tree().call_group("meteors", "queue_free")
	$MeteorTimer.start()
	$Player.global_position = $StartPosition.position
	$Player.velocity = Vector2.ZERO
	$Player.show()

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
	
	# Add randomness to the meteor rotation and rotation speed
	meteor.angular_velocity = randf_range(-PI/2, PI/2) * multiple_meteor_rotation_speed
	
	# Choose meteor velocity
	var velocity = Vector2(randf_range(min_meteor_speed, max_meteor_speed), 0.0)
	meteor.linear_velocity = velocity.rotated(direction) * multiply_meteor_velocity
	
	add_child(meteor)

func _on_hud_new_game():
	new_game()

func _on_dice_rolled_five():
	multiple_meteor_rotation_speed = 20
	multiply_meteor_velocity = 2
	$MeteorTimer.wait_time = 0.5

func _on_dice_rolled_non_five():
	multiple_meteor_rotation_speed = 1
	multiply_meteor_velocity = 1
	$MeteorTimer.wait_time = 1.5
