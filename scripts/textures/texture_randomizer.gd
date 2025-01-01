class_name TextureRandomizer
extends Node2D

# --- Variables --- #
@export var sprite: Sprite2D

@export var use_frames := true
# @@show_if(use_frames)
@export var total_frames: int = 1
# @@show_if(!use_frames)
@export var textures: Array[Texture2D] = []

# --- Functions --- #
func _ready():
	randomize_texture()

func randomize_texture() -> void:
	if use_frames:
		sprite.frame = randi_range(0, total_frames - 1)
	else:
		var texture = textures.pick_random()
		
		if texture:
			sprite.texture = texture
		else:
			sprite.hide()
