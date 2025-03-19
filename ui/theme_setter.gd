class_name ThemeSetter
extends Control

# --- Variables --- #
@export var color_key := ThemePreset.ColorValue.NORMAL

# --- Functions --- #
func _ready() -> void:
	if not is_in_group(&'theme_setter'):
		add_to_group(&'theme_setter')
	
	update_theme()

func update_theme(key := ThemePreset.ColorValue.NONE) -> void:
	var preset = Globals.theme_preset
	
	if not preset:
		return
	
	if key != ThemePreset.ColorValue.NONE:
		color_key = key
	
	self_modulate = preset.color_scale[color_key - 1]
