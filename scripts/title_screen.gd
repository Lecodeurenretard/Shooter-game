extends Control

func enter_game() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func press_title() -> void:
	$AnimationPlayer.play("title_press")

func release_title() -> void:
	$AnimationPlayer.play_backwards("title_press")
