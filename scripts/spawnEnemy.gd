extends Node2D

signal enemy_spawned(enemy : AnimatableBody2D)

@export var speed : float = 10.0

@export_category("Spawn time parameters")
@export var spawn_min : float = .1
@export var spawn_max : float = .5

const enemy_scene := preload("res://enemy.tscn")
@onready var WIN_WIDTH := get_window().size.x
@onready var WIN_HEIGHT := get_window().size.y
@onready var upper_left_corner := Vector2(-WIN_WIDTH/2.0, -WIN_HEIGHT/2.0)
@onready var bottom_right_corner := Vector2(WIN_WIDTH/2.0, WIN_HEIGHT/2.0)

func _ready() -> void:
	global_position = upper_left_corner
	$SpawnTimer.timeout.connect(spawn_enemy)

func _process(delta: float) -> void:
	get_parent().progress += speed * delta

func spawn_enemy():
	$SpawnTimer.wait_time = randf_range(spawn_min, spawn_max)
	
	var enemy := enemy_scene.instantiate()
	enemy.global_position = global_position + Vector2(WIN_WIDTH/2.0, WIN_HEIGHT/2.0)	# For some reason the global position needs to be offset
	%Player.add_sibling(enemy)
	
	emit_signal("enemy_spawned", enemy)
