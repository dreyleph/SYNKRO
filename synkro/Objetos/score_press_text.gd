extends Control

#perfect - bd7af8
#great - 2ab3b8
#good - f6d800
#ok - 3b8000
#miss - ee0000


func SetTextInfo(text: String):
	$ScoreLevelText.text = "[center]" + text
	
	match text:
		"PERFECT":
			$ScoreLevelText.set("theme_override_colors/default_color", Color("bd7af8"))
		"GREAT":
			$ScoreLevelText.set("theme_override_colors/default_color", Color("2ab3b8"))
		"GOOD":
			$ScoreLevelText.set("theme_override_colors/default_color", Color("f6d800"))
		"OK":
			$ScoreLevelText.set("theme_override_colors/default_color", Color("3b8000"))
		_:
			$ScoreLevelText.set("theme_override_colors/default_color", Color("ee0000"))
		
