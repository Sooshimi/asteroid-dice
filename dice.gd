extends RigidBody2D

var side_one = load("res://assets/dice/dice_1.png")
var side_two = load("res://assets/dice/dice_2.png")
var side_three = load("res://assets/dice/dice_3.png")
var side_four = load("res://assets/dice/dice_4.png")
var side_five = load("res://assets/dice/dice_5.png")
var side_six = load("res://assets/dice/dice_6.png")

var dice_sides = [side_one, side_two, side_three, side_four, side_five, side_six]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func roll():
	for i in 5:
		await $RollAnimationTimer.timeout
		$Sprite2D.texture = dice_sides[randi() % dice_sides.size()]

func _on_body_entered(body):
	if not "Wall" in body.name:
		roll()
		body.queue_free()
