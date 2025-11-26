extends Sprite2D

@onready var falling_key = preload("res://Objetos/falling_key.tscn")
@onready var score_text = preload("res://Objetos/score_press_text.tscn")
@export var key_name: String = ""

var falling_key_queue: Array = []

var perfect_press_limit: float = 70.0
var great_press_limit: float = 90.0
var good_press_limit: float = 105.0
var ok_press_limit: float = 120.0
var miss_press_limit: float = 140.0

var perfect_press_score: int = 300
var great_press_score: int = 200
var good_press_score: int = 100
var ok_press_score: int = 50

var key_to_pop: Sprite2D
var distance_from_pass: float

func _ready() -> void:
	$GlowOverlay.frame = frame + 4
	Signals.CreateFallingKey.connect(CreateFallingKey)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed(key_name, frame):
		Signals.KeylistenerPress.emit(key_name, 0)

	if falling_key_queue.size() > 0:
		if falling_key_queue.front().has_passed:
			falling_key_queue.pop_front()
			var st_inst_miss = score_text.instantiate()
			get_tree().get_root().call_deferred("add_child", st_inst_miss)
			st_inst_miss.SetTextInfo("MISS")
			st_inst_miss.global_position = global_position + Vector2(0.0, -40.0)
			Signals.register_miss()

	if Input.is_action_just_pressed(key_name) and falling_key_queue.size() > 0:
		var candidate_key: Sprite2D = falling_key_queue.front()
		distance_from_pass = abs(candidate_key.pass_limit - candidate_key.global_position.y)
		if distance_from_pass >= miss_press_limit:
			return

		key_to_pop = falling_key_queue.pop_front()
		$AnimationPlayer.stop()
		$AnimationPlayer.play("key_hit")

		var press_score_text: String = ""
		var added_score: int = 0

		if distance_from_pass < perfect_press_limit:
			added_score = perfect_press_score
			press_score_text = "PERFECT"
		elif distance_from_pass < great_press_limit:
			added_score = great_press_score
			press_score_text = "GREAT"
		elif distance_from_pass < good_press_limit:
			added_score = good_press_score
			press_score_text = "GOOD"
		elif distance_from_pass < ok_press_limit:
			added_score = ok_press_score
			press_score_text = "OK"
		elif distance_from_pass < miss_press_limit:
			key_to_pop.queue_free()
			var st_inst_miss2 = score_text.instantiate()
			get_tree().get_root().call_deferred("add_child", st_inst_miss2)
			st_inst_miss2.SetTextInfo("MISS")
			st_inst_miss2.global_position = global_position + Vector2(0.0, -40.0)
			Signals.register_miss()
			return

		key_to_pop.queue_free()
		if added_score > 0:
			Signals.register_hit(added_score)

		var st_inst = score_text.instantiate()
		get_tree().get_root().call_deferred("add_child", st_inst)
		st_inst.SetTextInfo(press_score_text)
		st_inst.global_position = global_position + Vector2(0.0, -40.0)

func CreateFallingKey(button_name: String) -> void:
	if button_name == key_name:
		var fk_inst: Sprite2D = falling_key.instantiate()
		get_tree().get_root().call_deferred("add_child", fk_inst)
		fk_inst.Setup(position.x, frame - 4)
		falling_key_queue.push_back(fk_inst)
		Signals.register_spawned_note(perfect_press_score)

func _on_random_spawn_timer_timeout() -> void:
	$RandomSpawnTimer.wait_time = randf_range(0.3, 1.0)
	$RandomSpawnTimer.start()
