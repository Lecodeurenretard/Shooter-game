extends CharacterBody2D

const ROTATION_OFFSET : float = PI/2
const bullet_scene : PackedScene = preload("res://scenes/bullet.tscn")
@export var HP : int = 5

var can_be_hit := true

signal create_bullet(bullet : StaticBody2D)
signal player_hit(hp_left : int)
signal player_dead

func _ready() -> void:
	if HP <= 0:
		player_dead.emit()
		queue_free()
	
	$InvicibilityTimer.timeout.connect(enable_hits)

func enable_hits() -> void:
	can_be_hit = true

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseButton or event.is_released():
		return;
	
	var bullet := bullet_scene.instantiate()
	add_sibling(bullet)
	get_parent().move_child(bullet, bullet.get_index() - 1)	# Move the bullet on top of the player (=> is drawn below)
	create_bullet.emit(bullet)

func _process(_delta: float) -> void:
	rotation = (get_global_mouse_position() - global_position).angle() + ROTATION_OFFSET;
				# Vector from player to mouse


func on_enemy_spawn(enemy: AnimatableBody2D) -> void:
	enemy.hit_player.connect(on_hit)

func on_hit() -> void:
	if not can_be_hit:
		return;
	can_be_hit = false
	
	HP -= 1
	player_hit.emit(HP)
	if HP <= 0:
		player_dead.emit()
		queue_free()
	$InvicibilityTimer.start()
