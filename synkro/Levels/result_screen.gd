extends Control
func _ready() -> void:
	var score: int = Signals.current_score
	var max_combo: int = Signals.max_combo
	var hits: int = Signals.total_hits
	var misses: int = Signals.total_misses
	var accuracy: float = Signals.get_accuracy()

	$ScoreLabel.text = "Score: " + str(score) + "PTS"
	$MaxComboLabel.text = "Max Combo: " + str(max_combo) + "X"
	$HitsLabel.text = "Acertos: " + str(hits) + "HITS"
	$MissesLabel.text = "Erros: " + str(misses)
	$AccuracyLabel.text = "Precisão: " + str(round(accuracy * 100) / 100.0) + "%"
