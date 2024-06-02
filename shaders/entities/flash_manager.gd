class_name FlashManager
extends Node2D

# --- Variables --- #
@export var sprite: Sprite2D

@export var hit_flash_time: float = 0.1

# --- Functions --- #
func set_flash_intensity(intensity: float) -> void:
	sprite.material.set_shader_parameter('intensity', intensity)

func _on_lost_health(_dmg: int, _entity: Entity) -> void:
	do_hit_flash()

func do_hit_flash() -> void:
	set_flash_intensity(1.0)
	await get_tree().create_timer(hit_flash_time).timeout
	set_flash_intensity(0.0)
