extends Sprite2D

@export var fall_speed: float = 14

var init_y_pos: float = -360

#booleana fica verdadeiro de nota passou da janela do input permitido
var has_passed: bool = false
var pass_limite = 290.0

func _init():
	set_process(false)

func _process(delta):
	global_position += Vector2(0, fall_speed)
	
	#Demonstra o tempo que leva ate nota chegar em area critica(na respectiva scrollspeed)
	if global_position.y > pass_limite and not $Timer.is_stopped():
		print($Timer.wait_time - $Timer.time_left)
		$Timer.stop()
		has_passed = true

func Setup(targe_x: float, target_frame: int):
	global_position = Vector2(targe_x, init_y_pos)
	frame = target_frame
	
	set_process(true)
	


func _on_destroy_timer_timeout():
	queue_free()
	
