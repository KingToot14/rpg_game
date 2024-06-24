extends CanvasLayer

# --- Variables --- #


# --- Functions --- #
func _ready() -> void:
	visible = false

#region Gameplay
func set_screen_shake(value: float) -> void:
	DataManager.options.screen_shake_intensity = value / 100.0

func set_timing_mode(value: StringName) -> void:
	DataManager.options.timing_mode = value

#endregion

#region Video
func set_theme_color(value: StringName) -> void:
	match value:
		&'blue':
			Globals.set_preset(load("res://resources/theme_presets/blue_preset.tres"))
		&'brown':
			Globals.set_preset(load("res://resources/theme_presets/brown_preset.tres"))
		&'green':
			Globals.set_preset(load("res://resources/theme_presets/green_preset.tres"))
		&'purple':
			Globals.set_preset(load("res://resources/theme_presets/purple_preset.tres"))
		&'red':
			Globals.set_preset(load("res://resources/theme_presets/red_preset.tres"))

#endregion
