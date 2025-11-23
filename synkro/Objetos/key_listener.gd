extends Sprite2D

@onready var falling_key = preload("res://Objetos/falling_key.tscn")
@onready var score_text = preload("res://Objetos/score_press_text.tscn")
@export var key_name: String = ""

var falling_key_queue = []


# se a distancia pressionada for menos que o limite, tal pontuacao é dada
var perfect_press_limit: float = 50 
var great_press_limit: float = 60
var good_press_limit: float = 75
var ok_press_limit: float = 90
# caso contrario, errou

var perfect_press_score: float  = 300
var great_press_score: float  = 200
var good_press_score: float  = 100
var ok_press_score: float  = 50

func _ready():
	$GlowOverlay.frame = frame + 4
	Signals.CreateFallingKey.connect(CreateFallingKey)

var key_to_pop: Sprite2D
var distance_from_pass: float

func _process(delta):
	
	if Input.is_action_just_pressed(key_name,frame):
		Signals.KeylistenerPress.emit(key_name)
	
	# confere se a nota para esse input
	if falling_key_queue.size() > 0:
		
		# ao passar remove da fila de notas
		if falling_key_queue.front().has_passed:
			falling_key_queue.pop_front()
			
			#Print MISS
			var st_inst = score_text.instantiate()
			get_tree().get_root().call_deferred("add_child", st_inst)
			st_inst.SetTextInfo("MISS")
			st_inst.global_position = global_position + Vector2(0 , -40	)
			Signals.ResetCombo.emit()
	# input e usado, destroi da fila e calcula distancia da area critica e quando foi apertado
			
	if Input.is_action_just_pressed(key_name) and falling_key_queue.size() > 0:
		key_to_pop = falling_key_queue.pop_front()
		
		distance_from_pass = abs(key_to_pop.pass_limit - key_to_pop.global_position.y)
		$AnimationPlayer.stop()
		$AnimationPlayer.play("key_hit")
		
		
		
		var press_score_text: String = ""
		if distance_from_pass < perfect_press_limit:
			Signals.IncrementScore.emit(perfect_press_score)
			press_score_text = "PERFECT"
			Signals.IncrementCombo.emit()
		elif distance_from_pass < great_press_limit:
			Signals.IncrementScore.emit(great_press_score)
			press_score_text = "GREAT"
			Signals.IncrementCombo.emit()
		elif distance_from_pass < good_press_limit:
			Signals.IncrementScore.emit(good_press_score)
			press_score_text = "GOOD"
			Signals.IncrementCombo.emit()
		elif distance_from_pass < ok_press_limit:
			Signals.IncrementScore.emit(ok_press_score)	
			press_score_text = "OK"
			Signals.IncrementCombo.emit()
		else:
			press_score_text = "MISS"
			Signals.ResetCombo.emit()
			
		key_to_pop.queue_free()
		
		var st_inst = score_text.instantiate()
		get_tree().get_root().call_deferred("add_child", st_inst)
		st_inst.SetTextInfo(press_score_text)
		st_inst.global_position = global_position + Vector2(0 , -40	)
		
		
func CreateFallingKey(button_name: String):
	if button_name == key_name:	
		var fk_inst = falling_key.instantiate()
		get_tree().get_root().call_deferred("add_child", fk_inst)
		fk_inst.Setup(position.x, frame + 1)
	
		falling_key_queue.push_back(fk_inst)


func _on_random_spawn_timer_timeout():
	#CreateFallingKey()
	$RandomSpawnTimer.wait_time = randf_range(0.3, 1)
	$RandomSpawnTimer.start()
