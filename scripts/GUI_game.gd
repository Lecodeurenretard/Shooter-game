extends CanvasLayer

func _enter_tree() -> void:
	%Player.ready.connect(func(): update_HP(%Player.HP)) 	# automaticly update the health
	$"/root/Score".score_set.connect(update_score)
	update_score($"/root/Score".score)
	
	offset = get_window().size/2.0
	# for some reason, the center of the layer is the upper right corner of the screen
	# the offset is not visible in the editor, only when running
	# changing the offset in the editor causes the position of the GUI to change in the editor too
	# those are the reasons this line exists


func update_HP(health : int) -> void:
	$Health/HP.text = str(health)

func update_score(points : int) -> void:
	$Points.text = str(points)
