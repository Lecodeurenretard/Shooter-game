extends AnimatableBody2D

@export var speed : float = 110
@onready var player : Node2D = get_node("../../Player")

signal hit_player()

func _ready() -> void:
	$AnimationPlayer.play("enemy_walk")
	
	player.create_bullet.connect(on_bullet_creation)
	for bullet in get_tree().get_nodes_in_group("bullets"):
		bullet.killed_something.connect(free_if_equal)

func _process(delta: float) -> void:
	var speedVec := (player.global_position - global_position).normalized() * speed
	var collider := move_and_collide(speedVec * delta)
	if(collider != null):
		if collider.get_collider().get_instance_id() == player.get_instance_id():
			emit_signal("hit_player")
		free()

func on_bullet_creation(bullet : StaticBody2D) -> void:
	bullet.killed_something.connect(free_if_equal)

func free_if_equal(toCompare : AnimatableBody2D):
	if toCompare.get_instance_id() == get_instance_id():
		queue_free()
