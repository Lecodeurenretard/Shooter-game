extends Panel

func _ready() -> void:
	refresh_highscore()

func refresh_highscore(parent_node : VBoxContainer = null) -> void:
	var template := $OtherHighscores/Container/Template
	if parent_node == null:
		parent_node = template.get_parent()
	
	var highscores : Dictionary[StringName, int] = $"/root/Score".get_highscores()
	for key in highscores.keys():
		var skip := false
		for present in parent_node.get_children():
			if key == present.name:	# same pseudo
				if int(present.get_child(1).text) >= highscores[key]:
					skip = true
					break
				# We're sure the node exists => we delete and remake it
				present.queue_free()
				break
		if skip:
			continue
		
		var node := template.duplicate()
		node.name = key
		node.get_child(0).text = key
		node.get_child(1).text = str(highscores[key])
		parent_node.add_child(node)
		node.visible = true
	
	reorder_highscore_board()

func handle_highscore_input() -> void:
	var user_name : StringName = $HSplitContainer/Pseudo.text
	$"/root/Score".save_highscore(user_name)
	$HSplitContainer/Pseudo.text = ""
	refresh_highscore()

func reorder_highscore_board() -> void:
	var sorted = $OtherHighscores/Container.get_children()
	sorted.sort_custom(
		func(a: Node, b: Node): 
			return int(a.get_child(1).text) > int(b.get_child(1).text)
	)
	for node in $OtherHighscores/Container.get_children():
		$OtherHighscores/Container.remove_child(node)
	for node in sorted:
		$OtherHighscores/Container.add_child(node)
