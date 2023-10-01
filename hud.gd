extends CanvasLayer

signal new_game

func _ready():
	$NewGameButton.hide()

func _process(delta):
	pass

func update_score(score):
	$ScoreLabel.text = str(score)

func hide_new_game_button():
	$NewGameButton.hide()

func show_new_game_button():
	$NewGameButton.show()

func _on_new_game_button_pressed():
	new_game.emit()
