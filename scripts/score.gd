extends Node2D

signal score_set(new_score : int)
signal passed_milestone()

var freeze_score := false
@export var milestone := 2000

var score : int = 0:
	set(val):
		if freeze_score:
			return;
		if score < val and (milestone <= val - score or val % milestone < score % milestone):
			passed_milestone.emit()
		score = max(0, val)
		score_set.emit(score)
