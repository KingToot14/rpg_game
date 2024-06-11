class_name BattleActionButton
extends BaseButton

# --- Variables --- #
@export var normal_texture: Texture2D
@export var hovered_texture: Texture2D

@export var backing_rect: TextureRect

# --- Functions --- #
func _on_mouse_entered():
	backing_rect.texture = hovered_texture

func _on_mouse_exited():
	backing_rect.texture = normal_texture
