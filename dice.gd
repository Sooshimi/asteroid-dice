extends RigidBody2D

var side_one = load("res://assets/dice/dice_1.png")
var side_two = load("res://assets/dice/dice_2.png")
var side_three = load("res://assets/dice/dice_3.png")
var side_four = load("res://assets/dice/dice_4.png")
var side_five = load("res://assets/dice/dice_5.png")
var side_six = load("res://assets/dice/dice_6.png")

var rolled_index
var rolled_side
var screen_size
var dice_sides = [side_one, side_two, side_three, side_four, side_five, side_six]

func _ready():
	screen_size = get_viewport_rect().size

func _integrate_forces(state):
	screen_wrap(state)

func roll():
	for i in 5:
		rolled_index = randi() % dice_sides.size()
		rolled_side = rolled_index + 1
		$Sprite2D.texture = dice_sides[rolled_index]
		await $RollAnimationTimer.timeout
	
	if rolled_side == 6:
		get_tree().call_group("meteors", "queue_free")

func _on_body_entered(body):
	roll()
	if body.name != "Player":
		body.queue_free()

func screen_wrap(state):
	state.transform.origin.x = wrapf(position.x, 0, screen_size.x)
	state.transform.origin.y = wrapf(position.y, 0, screen_size.y)
