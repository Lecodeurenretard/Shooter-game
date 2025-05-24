extends Path2D

@onready var WIN_WIDTH := get_window().size.x
@onready var WIN_HEIGHT := get_window().size.y
@onready var upper_left_corner := Vector2(-WIN_WIDTH/2.0, -WIN_HEIGHT/2.0)
@onready var bottom_right_corner := Vector2(WIN_WIDTH/2.0, WIN_HEIGHT/2.0)

func _ready() -> void:
	curve.clear_points()
	var points := [		# The corners of the screen
		upper_left_corner,
		Vector2(bottom_right_corner.x, upper_left_corner.y),
		bottom_right_corner,
		Vector2(upper_left_corner.x, bottom_right_corner.y),
		upper_left_corner
	]
	for point in points:
		curve.add_point(point)
