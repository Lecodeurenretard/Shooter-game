extends CanvasLayer

func _enter_tree() -> void:
	%Player.ready.connect(func(): update_HP(%Player.HP)) 	# automaticly update the health
	$"/root/Score".passed_milestone.connect(func(): $PointPanel/PointsNotification.play())
	$"/root/Score".score_set.connect(update_score)
	update_score($"/root/Score".score)
	
	get_tree().get_root().size_changed.connect(update_offset)
	update_offset()

func update_offset() -> void:
	offset = get_window().size/2.0
	# for some reason, the center of the layer is the upper right corner of the screen
	# the offset is not visible in the editor, only when running
	# changing the offset in the editor causes the position of the GUI to change in the editor too
	# those are the reasons this line exists

func update_HP(health : int) -> void:
	$HealthPanel/HP.text = str(health)

func update_score(points : int) -> void:
	$PointPanel/CenterContainer/Points.text = str(points)

func hide_ui() -> void:
	visible = false
