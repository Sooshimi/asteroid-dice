extends CanvasLayer

func _ready():
	pass

func _process(delta):
	pass

func update_score(score):
	$ScoreLabel.text = str(score)
