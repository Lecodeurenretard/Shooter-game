extends Panel

func _ready() -> void:
	refresh_highscore()

func refresh_highscore(parent_node : VBoxContainer = null) -> void:
	var template := $OtherHighscores/ScrollContainer/MarginContainer/Container/Template
	if parent_node == null:
		parent_node = template.get_parent()
	
	var highscores : Dictionary[StringName, int] = $"/root/Score".get_highscores()
	for key in highscores.keys():
		if check_and_delete_highscore(key, highscores[key], parent_node):
			continue
		
		var created_node := template.duplicate()
		created_node.name = key
		created_node.get_child(0).text = key
		created_node.get_child(1).text = str(highscores[key])
		parent_node.add_child(created_node)
		created_node.visible = true
	
	reorder_highscore_board()

func check_and_delete_highscore(to_search : StringName, to_search_highscore : int, highscore_container : Container) -> bool:
	for node in highscore_container.get_children():
		if to_search != node.name:	# different pseudo
			continue
		
		# if the registered highscore is lower than the displayed one
		if int(node.get_child(1).text) >= to_search_highscore:
			return true
		
		# We're sure the node exists => we delete and remake it
		node.queue_free()
		break
	return false

func handle_highscore_input(dummy_arg = null) -> void:
	var user_name : StringName = $HSplitContainer/Pseudo.text
	$"/root/Score".save_highscore(user_name)
	$HSplitContainer/Pseudo.text = ""
	refresh_highscore()

func reorder_highscore_board() -> void:
	var highscore_board := $OtherHighscores/ScrollContainer/MarginContainer/Container
	var sorted = highscore_board.get_children()
	sorted.sort_custom(
		func(a: Node, b: Node): 
			return int(a.get_child(1).text) > int(b.get_child(1).text)
	)
	for node in highscore_board.get_children():
		highscore_board.remove_child(node)
	for node in sorted:
		highscore_board.add_child(node)
