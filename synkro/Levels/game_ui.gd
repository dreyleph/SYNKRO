extends Control

var score: int = 0



func _ready():
	Signals.IncrementScore.connect(IncrementScore)
	
func IncrementScore(incr: int):
	score += incr
	%ScoreLabel.text = str(score) + " Pts"
