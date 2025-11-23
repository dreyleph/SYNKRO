extends Node2D

#colocar true antes do jogo para comecar edicao
const in_edit_mode: bool = true
var currente_level_name = "DESIVE"

var fk_fall_time: float = 2.2
var fk_output_arr = [[], [], [], []]

var level_info = {
	"DESIVE" = {
		"fk_times": "[[1, 1.5, 2],[2],[3],[4]]",
		"music": load("res://Music/【Arcaea】Désive-_-MisomyL-_2-lFD4KF1kA_.wav")
	}
}


func _ready():
	
	$MusicPlayer.stream = level_info.get(currente_level_name).get("music")
	$MusicPlayer.play()
	
	if in_edit_mode:
		Signals.KeylistenerPress.connect(KeylistenerPress)
	else:
		var fk_times = level_info.get(currente_level_name).get("fk_times")
		var fk_times_arr = str_to_var(fk_times)
		print(fk_times_arr[0])
		
		
		var counter: int = 0
		for key in fk_times_arr:
			
			var button_name: String = ""
			match counter:
				0:
					button_name = "button_D"
				1:
					button_name = "button_F"
				2:
					button_name = "button_K"
				3:
					button_name = "button_L"
			for delay in key:
				SpawnFallingKey(button_name, delay)
				
			counter += 1

func KeylistenerPress(button_name: String, array_num: int):
	#print(str(array_num) + " " + str($MusicPlayer.get_playback_position()))
	fk_output_arr[array_num].append($MusicPlayer.get_playback_position() - fk_fall_time)


func SpawnFallingKey(button_name: String, delay: float):
	await get_tree().create_timer(delay).timeout
	Signals.CreateFallingKey.emit(button_name)
	


func _on_music_player_finished() -> void:
	print(fk_output_arr)
