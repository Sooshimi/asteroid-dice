extends CanvasLayer

signal new_game

@onready var score_label := $ScoreLabel
@onready var new_game_button := $NewGameButton

func _ready():
	new_game_button.hide()

func _process(delta):
	pass

func update_score(score):
	score_label.text = str(score)

func hide_new_game_button():
	new_game_button.hide()

func show_new_game_button():
	new_game_button.show()

func _on_new_game_button_pressed():
	new_game.emit()
