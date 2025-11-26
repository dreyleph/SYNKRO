extends Sprite2D

@export var fall_speed: float = 8.5

var init_y_pos: float = -360.0
var has_passed: bool = false
var pass_limit: float = 290.0

const LATE_MISS_DISTANCE: float = 140.0

func _init() -> void:
	set_process(false)

func _process(delta: float) -> void:
	global_position += Vector2(0.0, fall_speed)
	var late_miss_y_limit: float = pass_limit + LATE_MISS_DISTANCE
	if global_position.y > late_miss_y_limit and not $Timer.is_stopped():
		$Timer.stop()
		has_passed = true

func Setup(target_x: float, target_frame: int) -> void:
	global_position = Vector2(target_x, init_y_pos)
	frame = target_frame
	set_process(true)

func _on_destroy_timer_timeout() -> void:
	queue_free()
