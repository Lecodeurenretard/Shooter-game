extends Node2D

signal score_set(new_score : int)
signal passed_milestone()

var freeze_score := false
@export var milestone := 2000
@export var savefile_name := "highscores.save"

var score : int = 0:
	set(val):
		if freeze_score:
			return;
		if score < val and (milestone <= val - score or val % milestone < score % milestone):
			passed_milestone.emit()
		score = max(0, val)
		score_set.emit(score)

func save_score(username : StringName) -> void:
	var savefile : FileAccess;
	if FileAccess.file_exists(savefile_name):
		savefile = FileAccess.open(savefile_name, FileAccess.READ_WRITE)
		var found_username := false
		
		while savefile.get_position() < savefile.get_length():	# Skip until finding the username
			if savefile.get_var() == username:
				found_username = true
				break
			assert(savefile.get_var() is int)	# highscores aren't useful here
		if not found_username:
			savefile.store_var(username)
	else:
		savefile = FileAccess.open(savefile_name, FileAccess.WRITE_READ)
		savefile.store_var("LeRetardatN (dev)")
		savefile.store_var(14450)
		savefile.store_var(username)
	
	savefile.store_var(score)	# overwriting the score

func save_highscore(username : StringName) -> bool:
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
