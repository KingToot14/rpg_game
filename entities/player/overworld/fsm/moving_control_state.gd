class_name MovingControlState
extends PlayerControlState

# --- Variables --- #
@export var movement_speed: float = 20.0

# --- Functions --- #
func handle_process() -> void:
	player.velocity = player.direction * movement_speed
	player.move_and_slide()
	player.update_texture()
