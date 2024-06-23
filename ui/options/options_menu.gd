extends CanvasLayer

# --- Variables --- #


# --- Functions --- #
func _ready() -> void:
	visible = false

#region Gameplay
func set_screen_shake(value: float) -> void:
	DataManager.options.screen_shake_intensity = value / 100.0
#endregion
