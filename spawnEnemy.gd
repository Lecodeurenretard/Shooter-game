extends Node2D

signal enemy_spawned(enemy : AnimatableBody2D)

var dir : Vector2 = Vector2.ZERO
@export var speed : float = 10.0

@export_category("Spawn time parameters")
@export var spawn_min : float = .1
@export var spawn_max : float = .5

const enemy_scene := preload("res://enemy.tscn")
@onready var WIN_WIDTH := get_window().size.x
@onready var WIN_HEIGHT := get_window().size.y

@onready var upper_left_corner := Vector2(-WIN_WIDTH/2.0, -WIN_HEIGHT/2.0)
@onready var bottom_right_corner := Vector2(WIN_WIDTH/2.0, WIN_HEIGHT/2.0)

func _enter_tree() -> void:
	dir = Vector2.RIGHT

func _ready() -> void:
	global_position = upper_left_corner
	$SpawnTimer.timeout.connect(spawn_enemy)

func _process(delta: float) -> void:
	if upper_left_corner.x >= global_position.x:
		dir = Vector2.UP
	if upper_left_corner.y >= global_position.y:
		dir = Vector2.RIGHT
	if global_position.x >= bottom_right_corner.x:
		dir = Vector2.DOWN
	if global_position.y >= bottom_right_corner.y:
		dir = Vector2.LEFT
	
	position += dir * speed * delta

func spawn_enemy():
	$SpawnTimer.wait_time = randf_range(spawn_min, spawn_max)
	
	var enemy := enemy_scene.instantiate()
	enemy.global_position = global_position
	add_child(enemy)
	emit_signal("enemy_spawned", enemy)
