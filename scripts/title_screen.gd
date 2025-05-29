extends Control

func _ready() -> void:
	get_tree().get_root().size_changed.connect(scale_img)

func scale_img() -> void:
	$LogoButt/CenterContainer/Logo.scale.x = get_window().size.x /1200.0
	$LogoButt/CenterContainer/Logo.scale.y = get_window().size.y /600.0

func enter_game() -> void:
	$"/root/Score".freeze_score = false
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func press_title() -> void:
	$AnimationPlayer.play("title_press")

func release_title() -> void:
	$AnimationPlayer.play_backwards("title_press")
