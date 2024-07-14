@tool
class_name TextureVariant
extends Node

# --- Variables --- #
@export var sprite: Sprite2D

@export var variant := 0

# --- Functions --- #
func _ready() -> void:
	update_texture()

func randomize_variant() -> void:
	variant = randi_range(0, sprite.hframes * sprite.vframes - 1)
	update_texture()

func update_texture() -> void:
	sprite.frame = variant
