extends Node2D

const sc_game_over := preload("res://scenes/GameOver.tscn")
const sc_pause := preload("res://scenes/PauseInterface.tscn")

@onready var WIN_DIMENSIONS := get_window().size

@export var disable_pause := false

signal pause()
signal unpause()

var is_game_paused := false
var sc_pause_instance : Node = null 

func _ready() -> void:
	get_tree().get_root().size_changed.connect(update_window_dimensions)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not disable_pause:
		if is_game_paused:
			handle_unpause()
		else:
			handle_pause()

func to_game_over() -> void:
	get_tree().change_scene_to_packed(sc_game_over)

func update_window_dimensions() -> void:
	WIN_DIMENSIONS = get_window().size

func handle_pause() -> void:
	if disable_pause:
		return;
	
	pause.emit()
	is_game_paused = true
	
	sc_pause_instance = sc_pause.instantiate()
	
	sc_pause_instance.continuing.connect(handle_unpause)
	
	add_sibling(sc_pause_instance)

func handle_unpause() -> void:
	# Can unpause when pause is disabled
	unpause.emit()
	is_game_paused = false
	sc_pause_instance.queue_free()
	sc_pause_instance = null


func prevent_pause() -> void:
	disable_pause = true
