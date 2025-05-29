extends StaticBody2D

## How much the bullet's spawn position is shifted from the player's position 
@export var spawn_pos_shift : float = 100
@export var speed : float = 400

signal killed_something(smth : CollisionObject2D)
@onready var base_node := get_node("..").get_tree().get_root().get_child(1)

var speedVec := Vector2.ZERO
var dir := Vector2.ZERO:
	set(val):
		dir = val
		speedVec = val * speed


func _enter_tree() -> void:
	dir = (get_global_mouse_position() - global_position).normalized()
	position += dir * spawn_pos_shift	# offset the bullet toward the barrel

func _physics_process(delta: float) -> void:
	if base_node.is_game_paused:
		return;

	var collider := move_and_collide(speedVec * delta)
	if collider != null:
		killed_something.emit(collider.get_collider())
		queue_free()
