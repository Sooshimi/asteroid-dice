extends RigidBody2D

@export var hp := 1

var meteor_sprite : int

@onready var animation_player := $AnimationPlayer
@onready var collision_shape := $CollisionShape2D

func _ready():
	meteor_sprite = randi() % 2
	
	if meteor_sprite == 0:
		animation_player.play("idle_1")
	else:
		animation_player.play("idle_2")

func _process(delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	get_parent().add_on_screen_meteor_count(-1)
	queue_free()

func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "destroy_1") || (anim_name == "destroy_2"):
		queue_free()
