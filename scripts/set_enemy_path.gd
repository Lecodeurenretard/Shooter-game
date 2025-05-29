extends Path2D

func _ready() -> void:
	get_tree().get_root().size_changed.connect(set_points)
	set_points()

func set_points() -> void:
	curve.clear_points()
	
	var screen_dim			:= get_window().size
	var upper_left_corner	:= -screen_dim/2.0
	var bottom_right_corner	:= +screen_dim/2.0
	var points := [		# The corners of the screen
		upper_left_corner,
		Vector2(bottom_right_corner.x, upper_left_corner.y),
		bottom_right_corner,
		Vector2(upper_left_corner.x, bottom_right_corner.y),
		upper_left_corner
	]
	for point in points:
		curve.add_point(point)
