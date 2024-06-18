class_name ThemeSetter
extends Control

# --- Variables --- #
@export var key: StringName

# --- Functions --- #
func _ready() -> void:
	update_theme()

func update_theme(curr_key: StringName = &"") -> void:
	var preset = Globals.theme_preset
	
	if not preset:
		return
	
	if curr_key == &"":
		curr_key = key
	
	match curr_key:
		&'light':
			self_modulate = preset.light_color
		&'normal':
			self_modulate = preset.normal_color
		&'dark':
			self_modulate = preset.dark_color
		&'accent_text':
			self_modulate = preset.accent_text_color
