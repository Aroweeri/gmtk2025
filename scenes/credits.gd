extends Label

func _ready():
	var credits = FileAccess.get_file_as_string("credits.txt")
	text = credits
