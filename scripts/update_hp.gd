extends Label

func _enter_tree() -> void:
	%Player.ready.connect(func(): update(%Player.HP)) 	# automaticly update the health

func update(health : int) -> void:
	text = str(health)
