extends Node2D

signal score_set(new_score : int)

var score : int = 0:
	set(val):
		score = max(0, val)
		score_set.emit(score)
