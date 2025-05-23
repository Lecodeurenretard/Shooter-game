extends CharacterBody2D

const ROTATION_OFFSET : float = PI/2
const bullet_scene : PackedScene = preload("res://bullet.tscn")
@export var HP : int = 5

signal create_bullet(bullet : StaticBody2D)
signal player_dead

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseButton or event.is_released():
		return;
	
	var bullet := bullet_scene.instantiate()
	add_sibling(bullet)
	emit_signal("create_bullet", bullet)

func _process(_delta: float) -> void:
	rotation = (get_global_mouse_position() - global_position).angle() + ROTATION_OFFSET;
				# Vector from player to mouse


func on_enemy_spawn(enemy: AnimatableBody2D) -> void:
	enemy.hit_player.connect(on_hit)

func on_hit():
	HP -= 1
	if HP <= 0:
		emit_signal("player_dead")
