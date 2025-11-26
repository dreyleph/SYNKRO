extends Node2D

signal IncrementScore(incr: int)
signal IncrementCombo()
signal ResetCombo()

signal CreateFallingKey(button_name: String)
signal KeylistenerPress(button_name: String, array_num: int)

signal StatsChanged

var current_score: int = 0
var current_combo: int = 0
var max_combo: int = 0
var total_hits: int = 0
var total_misses: int = 0
var max_possible_score: int = 0

func reset_stats() -> void:
	current_score = 0
	current_combo = 0
	max_combo = 0
	total_hits = 0
	total_misses = 0
	max_possible_score = 0

func register_spawned_note(perfect_score: int) -> void:
	max_possible_score += perfect_score

func register_hit(added_score: int) -> void:
	current_score += added_score
	total_hits += 1
	current_combo += 1
	if current_combo > max_combo:
		max_combo = current_combo
	IncrementScore.emit(added_score)
	IncrementCombo.emit()
	StatsChanged.emit()

func register_miss() -> void:
	total_misses += 1
	current_combo = 0
	ResetCombo.emit()
	StatsChanged.emit()

func get_accuracy() -> float:
	if max_possible_score <= 0:
		return 0.0
	return float(current_score) / float(max_possible_score) * 100.0
