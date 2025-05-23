extends Node2D

var game_over := preload("res://GameOver.tscn")

func to_game_over() -> void:
	get_tree().change_scene_to_packed(game_over)
