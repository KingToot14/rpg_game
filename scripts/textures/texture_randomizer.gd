class_name TextureRandomizer
extends Sprite2D

# --- Variables --- #
@export var total_frames: int = 1

# --- Functions --- #
func _ready():
	randomize_texture()

func randomize_texture() -> void:
	frame = randi_range(0, total_frames - 1)
