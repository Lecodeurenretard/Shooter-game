extends Control

func restart() -> void:
	$"/root/Score".score = 0
	get_tree().change_scene_to_file("res://scenes/main.tscn")	# load the scene at runtime to reset it


func quit() -> void:
	get_tree().quit()
