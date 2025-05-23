extends StaticBody2D

@export var speed : float = 10

signal killed_something(smth : CollisionObject2D)

var speedVec := Vector2.ZERO
var dir := Vector2.ZERO:
	set(val):
		speedVec = val * speed


func _enter_tree() -> void:
	dir = (get_global_mouse_position() - global_position).normalized()

func _physics_process(delta: float) -> void:
	var collider := move_and_collide(speedVec * delta)
	if(collider != null):
		emit_signal("killed_something", collider.get_collider())
		free()
