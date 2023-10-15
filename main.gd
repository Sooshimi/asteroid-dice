extends Node

@export var laser_scene : PackedScene
@export var meteor_scene : PackedScene
@export var min_meteor_speed := 150.0
@export var max_meteor_speed := 250.0

# Initial meteor rotation speed and velocity on game start
var multiple_meteor_rotation_speed := 1
var multiply_meteor_velocity := 1
var meteor_safe_spawn : bool
var direction : float
var score : int
var rolled_two : bool
var initial_child_count : int
var on_screen_meteor_count : int
var stop_score_update := false

signal reset_game

@onready var meteor_timer := $MeteorTimer
@onready var meteor_spawn_location := $MeteorPath/MeteorSpawnLocation
@onready var meteor_safe_spawn_location := $MeteorPath/MeteorSafeSpawnLoc
@onready var hud := $HUD
@onready var player := $Player
@onready var shoot_cooldown_timer := $ShootCooldownTimer
@onready var start_position := $StartPosition
@onready var laser_point := $Player/LaserPoint
@onready var laser_point_left := $Player/LaserPointLeft
@onready var laser_point_right := $Player/LaserPointRight
@onready var auto_roll_timer := $Dice/AutoRollTimer

func _ready():
	initial_child_count = get_child_count()
	new_game()
	hud.hide_new_game_button()

func _process(_delta):
	if player.is_visible_in_tree() && Input.is_action_pressed("shoot") && shoot_cooldown_timer.is_stopped():
		fire_laser()

func fire_laser():
	shoot_cooldown_timer.start()
	var laser := laser_scene.instantiate()
	laser.position = laser_point.global_position
	laser.rotation = laser_point.global_rotation
	add_child(laser)
	
	if rolled_two:
		var laser_one := laser_scene.instantiate()
		var laser_two := laser_scene.instantiate()
		laser_one.position = laser_point_left.global_position
		laser_one.rotation = laser_point_left.global_rotation
		laser_two.position = laser_point_right.global_position
		laser_two.rotation = laser_point_right.global_rotation
		laser.speed = 100
		laser_one.speed = 100
		laser_two.speed = 100
		add_child(laser_one)
		add_child(laser_two)

func game_over():
	hud.show_new_game_button()
	shoot_cooldown_timer.stop()
	meteor_timer.stop()
	auto_roll_timer.stop()
	stop_score_update = true

func get_stop_score_update() -> bool:
	return stop_score_update

func new_game():
	reset_game.emit()
	
	# Reset score
	score = 0
	hud.update_score(score)
	hud.hide_new_game_button()
	stop_score_update = false
	
	# Destroy all meteors and reset meteors back to default values
	get_tree().call_group("meteors", "queue_free")
	meteor_timer.start()
	multiple_meteor_rotation_speed = 1
	multiply_meteor_velocity = 1
	meteor_timer.wait_time = 1.5
	rolled_two = false
	
	# Reset player
	player.global_position = start_position.position
	player.velocity = Vector2.ZERO
	player.show()
	
	# Start dice auto roll timer
	auto_roll_timer.start()

func _on_meteor_timer_timeout():
	# Create new instance of meteor
	var meteor := meteor_scene.instantiate()
	
	# Set location of MeteorSpawnLocation node along MeteorPath
	meteor_spawn_location.progress_ratio = randf()
	
	meteor_safe_spawn_location.progress_ratio = meteor_spawn_location.progress_ratio
	
	# Set the direction of the meteor perpendicular to the path
	direction = meteor_safe_spawn_location.rotation + PI/2
	
	# Set meteor's position to the chosen random spawn location
	meteor.position = meteor_safe_spawn_location.position
	
	# Add randomness to the meteor direction (within a conical range)
	direction += randf_range(-PI/4, PI/4)
	
	# Add randomness to the meteor rotation and rotation speed
	meteor.angular_velocity = randf_range(-PI/2, PI/2) * multiple_meteor_rotation_speed
	
	# Choose meteor velocity
	var velocity = Vector2(randf_range(min_meteor_speed, max_meteor_speed), 0.0)
	meteor.linear_velocity = velocity.rotated(direction) * multiply_meteor_velocity
	
	add_child(meteor)
	
	on_screen_meteor_count = get_child_count() - initial_child_count

func _on_hud_new_game():
	new_game()

func _on_dice_rolled_six():
	score += on_screen_meteor_count
	if !stop_score_update:
		hud.update_score(score)

func _on_dice_rolled_five():
	multiple_meteor_rotation_speed = 20
	multiply_meteor_velocity = 2
	meteor_timer.wait_time = 0.5

func _on_dice_rolled_non_five():
	multiple_meteor_rotation_speed = 1
	multiply_meteor_velocity = 1
	meteor_timer.wait_time = 1.5

func _on_dice_rolled_two():
	rolled_two = true

func _on_dice_rolled_non_two():
	rolled_two = false

func _on_area_2d_body_entered(_body):
	meteor_safe_spawn = false
	meteor_safe_spawn_location.progress_ratio = randf()

func _on_area_2d_body_exited(_body):
	meteor_safe_spawn = true

func add_on_screen_meteor_count(num: int):
	on_screen_meteor_count += num
