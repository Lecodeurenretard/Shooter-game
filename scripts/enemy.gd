extends AnimatableBody2D

const flee_texture := preload("res://img/png/enemy_worry.png")

@export var speed 				: float = 140

## Score when killed
@export var score_killed 		: int = 50
## Score when hit the player
@export var score_hit_player 	: int = -10

@export var prevent_pause_animation := false

@onready var player : Node2D = get_node("../Player")	# Unique name inaccessible from this scene 

@onready var base_node := player.get_tree().get_root().get_child(1)

signal hit_player()

func _ready() -> void:
	if not base_node.is_game_paused:
		$AnimationPlayer.play("enemy_walk")
	
	base_node.pause.connect(pausing)
	base_node.unpause.connect(unpausing)
	
	player.create_bullet.connect(on_bullet_creation)
	player.player_suicided.connect(flee)
	
	for bullet in get_tree().get_nodes_in_group("bullets"):
		bullet.killed_something.connect(die_if_equal)

func _process(delta: float) -> void:
	if base_node.is_game_paused:
		return;

	var speedVec := (player.global_position - global_position).normalized() * speed
	var collider := move_and_collide(speedVec * delta)
	if(collider != null):
		if collider.get_collider().get_instance_id() == player.get_instance_id():
			$"/root/Score".score += score_hit_player
			hit_player.emit()
		
		queue_free()

func on_bullet_creation(bullet : StaticBody2D) -> void:
	bullet.killed_something.connect(die_if_equal)

func pausing() -> void:
	if not prevent_pause_animation:
		$AnimationPlayer.pause()

func unpausing() -> void:
	if not prevent_pause_animation:
		$AnimationPlayer.play("enemy_walk")

func die_if_equal(toCompare : AnimatableBody2D):
	if toCompare.get_instance_id() == get_instance_id():
		$"/root/Score".score += score_killed
		
		collision_layer = 0	# Prevent bullet from colling
		collision_mask = 0	
		visible = false
		
		$SoundEffects.pitch_scale = randf_range(.9, 1.1)
		$SoundEffects.play()
		await $SoundEffects.finished 
		queue_free()

func flee() -> void:
	speed *= -.5
	$EnemySprite.texture = flee_texture
	# $EnemySprite.flip_h = true	# ugly 
