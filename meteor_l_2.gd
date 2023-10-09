extends RigidBody2D

@export var hp := 1

var meteor_one := load("res://assets/meteors/meteorLarge1.png")
var meteor_two := load("res://assets/meteors/meteorLarge2.png")
var meteor_list := [meteor_one, meteor_two]
var meteor_index : int

@onready var meteor_sprite := $Sprite2D

func _ready():
	meteor_index = randi() % meteor_list.size()
	meteor_sprite.texture = meteor_list[meteor_index]

func _process(delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	get_parent().add_on_screen_meteor_count(-1)
	queue_free()
