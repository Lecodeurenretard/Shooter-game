extends AnimatableBody2D

@export var speed 				: float = 110

## Score when killed
@export var score_killed 			: int = 50
## Score when hit the player
@export var score_hit_player 	: int = -10

@onready var player : Node2D = get_node("../Player")	# Unique name inaccessible from this scene 

signal hit_player()

func _ready() -> void:
	$AnimationPlayer.play("enemy_walk")
	
	player.create_bullet.connect(on_bullet_creation)
	for bullet in get_tree().get_nodes_in_group("bullets"):
		bullet.killed_something.connect(die_if_equal)

func _process(delta: float) -> void:
	var speedVec := (player.global_position - global_position).normalized() * speed
	var collider := move_and_collide(speedVec * delta)
	if(collider != null):
		if collider.get_collider().get_instance_id() == player.get_instance_id():
			$"/root/Score".score += score_hit_player
			hit_player.emit()
		queue_free()

func on_bullet_creation(bullet : StaticBody2D) -> void:
	bullet.killed_something.connect(die_if_equal)

func die_if_equal(toCompare : AnimatableBody2D):
	if toCompare.get_instance_id() == get_instance_id():
		$"/root/Score".score += score_killed
		queue_free()
