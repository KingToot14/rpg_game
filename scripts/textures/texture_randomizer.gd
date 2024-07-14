class_name TextureRandomizer
extends Node2D

# --- Variables --- #
@export var sprite: Node2D

@export var total_frames: int = 1

# --- Functions --- #
func _ready():
	randomize_texture()

func randomize_texture() -> void:
	sprite.frame = randi_range(0, total_frames - 1)
