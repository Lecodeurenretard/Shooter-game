extends Node2D

signal enemy_spawned(enemy : AnimatableBody2D)

@export var speed : float = 10.0

@export_category("Spawn interval")
@export var spawn_min : float = .1
@export var spawn_max : float = .7

const enemy_scene := preload("res://scenes/enemy.tscn")
@onready var WIN_DIMENSIONS := get_window().size
@onready var WIN_WIDTH := WIN_DIMENSIONS.x
@onready var WIN_HEIGHT := WIN_DIMENSIONS.y
@onready var upper_left_corner := -WIN_DIMENSIONS/2.0
@onready var bottom_right_corner := WIN_DIMENSIONS/2.0

## The remmaining time before the timer stops
## Is only updated on pause (else use the `.time_left` property of the timer)
var timer_time_left := 0.0

func _ready() -> void:
	global_position = upper_left_corner
	$SpawnTimer.timeout.connect(spawn_enemy)

func _process(delta: float) -> void:
	if get_tree().get_root().get_child(1).is_game_paused:	# The `Base` node
		return;
	get_parent().progress += speed * delta

func spawn_enemy():
	$SpawnTimer.wait_time = randf_range(spawn_min, spawn_max)
	
	var enemy := enemy_scene.instantiate()
	enemy.global_position = global_position + Vector2(WIN_WIDTH/2.0, WIN_HEIGHT/2.0)	# For some reason the global position needs to be offset
	%Player.add_sibling(enemy)
	
	enemy_spawned.emit(enemy)

func pausing() -> void:
	timer_time_left = $SpawnTimer.time_left
	$SpawnTimer.stop()

func unpausing() -> void:
	$SpawnTimer.start(timer_time_left)
