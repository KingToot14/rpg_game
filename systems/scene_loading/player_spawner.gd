class_name PlayerSpawner
extends Node2D

# --- Variables --- #
@export var starting_position: Node2D
@export_file("*tscn") var player_path: String

# --- Functions --- #
func _ready():
	AsyncLoader.new(player_path, spawn_player)

func spawn_player(player_scene: PackedScene) -> void:
	var player = player_scene.instantiate()
	
	var player_pos := Globals.player_area_pos
	
	if player_pos.x < -50:
		player_pos = starting_position.global_position
	
	player.global_position = player_pos
	SceneManager.add_node(player)
