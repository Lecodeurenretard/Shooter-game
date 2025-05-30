extends Node2D

signal score_set(new_score : int)
signal passed_milestone()

var freeze_score := false
@export var milestone := 2000
@export var savefile_name := "highscores.save"
@export var authorized_chars : Array[String] = [
	'_',
	'-',
	':',
	'<',
	'!',
	',',
	';'
]

var score : int = 0:
	set(val):
		if freeze_score:
			return;
		if score < val and (milestone <= val - score or val % milestone < score % milestone):
			passed_milestone.emit()
		score = max(0, val)
		score_set.emit(score)

func new_save_file(filename : String) -> FileAccess:
	var savefile = FileAccess.open(filename, FileAccess.WRITE_READ)
	savefile.store_var("LeRetardatN")
	savefile.store_var(17100)
	return savefile
	

func save_score(username : StringName) -> void:
	if not FileAccess.file_exists(savefile_name):
		var savefile := new_save_file(savefile_name)
		
		savefile.store_var(format_name(username))
		savefile.store_var(score)	# overwriting the score
		return;
	
	var savefile := FileAccess.open(savefile_name, FileAccess.READ_WRITE)
	var found_username := false
	
	while savefile.get_position() < savefile.get_length():	# Looping through thje file
		if savefile.get_var() == username:
			found_username = true
			break
		assert(savefile.get_var() is int)	# highscores aren't useful here
	if not found_username:
		savefile.store_var(username)	# Cursor at eof
	
	savefile.store_var(score)	# overwriting the score

func save_highscore(username : StringName) -> bool:
	username = format_name(username)
	var highscores :=  get_highscores()
	if not highscores.has(username) or highscores[username] < score:
		save_score(username)
		return true
	return false

func get_highscores() -> Dictionary[StringName, int]:
	if not FileAccess.file_exists(savefile_name):
		return {}
	
	var res : Dictionary[StringName, int];
	var savefile := FileAccess.open(savefile_name, FileAccess.READ)
	while savefile.get_position() < savefile.get_length():
		var pseudo : StringName = savefile.get_var()
		res[pseudo] = savefile.get_var()
	return res

func format_name(pseudo : String) -> String:
	var res := ""
	for character in pseudo:
		var is_letter : bool;
		if 65 <= character.unicode_at(0) and character.unicode_at(0) <= 90:	# is capital letter
			character = character.to_lower()
			is_letter = true
		else:
			is_letter  = 97 <= character.unicode_at(0) and character.unicode_at(0) <= 122
		var is_number := 48 <= character.unicode_at(0) and character.unicode_at(0) <= 57
		var is_allowed_special : bool = authorized_chars.has(character)
		
		if is_letter or is_number or is_allowed_special:
			res += character
	return res
