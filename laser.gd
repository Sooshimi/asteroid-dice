extends Area2D

@onready var main := get_parent()
@onready var hud := main.get_node("HUD")
@onready var dice := main.get_node("Dice")
@export var speed := 1500

var vector := Vector2.ZERO
var score : int

@onready var screen_size : Vector2
@onready var destroy_meteor_anim_timer := $DestroyMeteorAnimTimer

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	vector.y = -1
	position += vector.rotated(rotation) * speed * delta
	
	if dice.rolled_three:
		screen_wrap()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	queue_free()
	
	if body.name == "Dice":
		if body.roll_ready:
			body.roll()
	else:
		body.hp -= 1
		if body.hp == 0:
			main.score += 1
			hud.update_score(main.score)
			
			if body.meteor_sprite == 1:
				body.animation_player.play("destroy_1")
			else:
				body.animation_player.play("destroy_2")

func screen_wrap():
	position.x = wrapf(position.x, 0, screen_size.x)
	position.y = wrapf(position.y, 0, screen_size.y)
