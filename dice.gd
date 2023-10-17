extends RigidBody2D

var side_one := load("res://assets/dice/dice_1.png")
var side_two := load("res://assets/dice/dice_2.png")
var side_three := load("res://assets/dice/dice_3.png")
var side_four := load("res://assets/dice/dice_4.png")
var side_five := load("res://assets/dice/dice_5.png")
var side_six := load("res://assets/dice/dice_6.png")

var rolled_index : int
var rolled_side : int
var screen_size : Vector2
var dice_sides := [side_one, side_two, side_three, side_four, side_five, side_six]
var roll_ready : bool
var reset_game : bool
var rolled_three : bool

signal rolled_six
signal rolled_five
signal rolled_non_five
signal rolled_four
signal rolled_non_four
signal rolled_two
signal rolled_non_two

@onready var dice_sprite := $Sprite2D
@onready var roll_animation_timer := $RollAnimationTimer
@onready var roll_cooldown_timer := $RollCooldownTimer
@onready var auto_roll_timer := $AutoRollTimer

func _ready():
	screen_size = get_viewport_rect().size
	roll_ready = true

func _integrate_forces(state):
	screen_wrap(state)
	
	if reset_game:
		state.transform = Transform2D(180, Vector2(400,100))
		linear_velocity = Vector2(25,50)
		reset_game = false

func roll():
	if roll_ready:
		auto_roll_timer.start()
		roll_cooldown_timer.start()
		roll_ready = false
	
		for i in 5:
			rolled_index = randi() % dice_sides.size()
			rolled_side = rolled_index + 1
			dice_sprite.texture = dice_sides[rolled_index]
			await roll_animation_timer.timeout
		
		if rolled_side == 6:
			rolled_six.emit()
			# All on-screen meteors get destroyed
			var meteors = get_tree().get_nodes_in_group("meteors")
			for meteor in meteors:
				if meteor.meteor_sprite == 1:
					meteor.animation_player.play("destroy_1")
				else:
					meteor.animation_player.play("destroy_2")
			rolled_non_five.emit()
			rolled_non_four.emit()
			rolled_non_two.emit()
			rolled_three = false
		if rolled_side == 5:
			# Meteors on (a)steroids
			rolled_five.emit()
			rolled_non_four.emit()
			rolled_non_two.emit()
			rolled_three = false
		if rolled_side == 4:
			# Revert player controls
			rolled_four.emit()
			rolled_non_five.emit()
			rolled_non_two.emit()
			rolled_three = false
		if rolled_side == 3:
			rolled_three = true
			rolled_non_five.emit()
			rolled_non_four.emit()
			rolled_non_two.emit()
		if rolled_side == 2:
			# More lasers
			rolled_non_five.emit()
			rolled_non_four.emit()
			rolled_two.emit()
			rolled_three = false
		if rolled_side == 1:
			# Default
			rolled_non_five.emit()
			rolled_non_four.emit()
			rolled_non_two.emit()
			rolled_three = false

func _on_body_entered(body):
	roll()
	
	if body.name != "Player":
		if body.meteor_sprite == 1:
			body.animation_player.play("destroy_1")
		else:
			body.animation_player.play("destroy_2")
		
		get_parent().add_on_screen_meteor_count(-1)
		if !get_parent().get_stop_score_update():
			get_parent().score -= 1
			get_parent().get_node("HUD").update_score(get_parent().score)

func screen_wrap(state):
	state.transform.origin.x = wrapf(position.x, 0, screen_size.x)
	state.transform.origin.y = wrapf(position.y, 0, screen_size.y)

func _on_dice_cooldown_timer_timeout():
	roll_ready = true

func _on_auto_roll_timer_timeout():
	roll()

func _on_main_reset_game():
	reset_game = true
