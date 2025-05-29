extends CharacterBody2D

const ROTATION_OFFSET : float = PI/2
const bullet_scene : PackedScene = preload("res://scenes/bullet.tscn")

@export var HP : int = 5
@export_range(0, 100) var suicide_penalty : float = 0

@export_category("Cheats")
@export var can_be_paused := true	# disabled the player is Dio
@export var can_be_hit := true

@export_category("Explosion parameters")
## The time took by the explosion when suiciding
@export var explosion_time : float = 2.0
@export var explosion_overflow := Vector2(2200, 2400)
@export var explosion_camera_shake := 5

@onready var base_node := get_node("..")
@onready var explosionSprite := get_node("../Explosion")

signal create_bullet(bullet : StaticBody2D)
signal player_hit(hp_left : int)
signal player_suicided
signal player_dead

func _ready() -> void:
	if HP <= 0:
		player_dead.emit()
		queue_free()
	
	$InvicibilityTimer.timeout.connect(enable_hits)

func enable_hits() -> void:
	can_be_hit = true

func _input(event: InputEvent) -> void:
	if base_node.is_game_paused and can_be_paused:
		return;
	
	# Disabling shooting if the cooldown isn't finished. If the game is paused, ignore the cooldown
	var cooldown : bool = $CooldownTimer.is_stopped() or base_node.is_game_paused
	if event.is_action_pressed("shoot") and not explosionSprite.visible and cooldown:
		if not base_node.is_game_paused:
			$CooldownTimer.start()
		
		var bullet := bullet_scene.instantiate()
		add_sibling(bullet)
		get_parent().move_child(bullet, bullet.get_index() - 1)	# Move the bullet on top of the player (=> is drawn above the bullet)
		create_bullet.emit(bullet)
		return
	
	# also checking for pause because even if the player cheats, they should not be able to suicide while paused
	if event.is_action_pressed("suicide") and not base_node.is_game_paused:
		player_suicided.emit()
		await nuke()
		player_dead.emit()

func nuke() -> void:
	explosionSprite.visible = true
	var nb_iter : float = explosion_time / $AnimationTimer.wait_time
	var camera := get_node("../Camera2D")
	
	$"/root/Score".score *= 1 - suicide_penalty/100
	$"/root/Score".freeze_score = true
	
	$Jakito.pitch_scale = randf_range(.001, 2)
	$Jakito.play()
	
	$AnimationTimer.start()
	for i in range(nb_iter):
		explosionSprite.texture.width +=  (get_window().size.x + explosion_overflow.x) / nb_iter
		explosionSprite.texture.height += (get_window().size.y + explosion_overflow.y) / nb_iter
		camera.offset = Vector2(
			randf_range(-explosion_camera_shake, explosion_camera_shake) * i,
			randf_range(-explosion_camera_shake, explosion_camera_shake) * i
		)
		await $AnimationTimer.timeout

func _process(_delta: float) -> void:
	if can_be_paused and base_node.is_game_paused:
		return;

	rotation = (get_global_mouse_position() - global_position).angle() + ROTATION_OFFSET;
				# Vector from player to mouse


func on_enemy_spawn(enemy: AnimatableBody2D) -> void:
	enemy.hit_player.connect(on_hit)

func on_hit() -> void:
	if not can_be_hit or not $InvicibilityTimer.is_stopped():
		return;
	
	HP -= 1
	player_hit.emit(HP)
	
	$HitSound.pitch_scale = randf_range(.9, 1.2)
	$HitSound.play()
	
	$InvicibilityTimer.start()
	if HP <= 0:
		player_dead.emit()
		queue_free()
