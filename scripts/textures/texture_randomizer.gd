class_name TextureRandomizer
extends Sprite2D

# --- Variables --- #
@export var textures: Array[Texture2D]

# --- Functions --- #
func _ready():
	randomize_texture()

func randomize_texture() -> void:
	texture = textures[randi_range(0, len(textures) - 1)]
