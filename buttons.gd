extends Control

func restart() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func quit() -> void:
	get_tree().quit()
