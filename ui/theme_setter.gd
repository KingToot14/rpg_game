class_name ThemeSetter
extends Control

# --- Variables --- #
@export var key: StringName

# --- Functions --- #
func _ready() -> void:
	if not is_in_group(&'theme_setter'):
		add_to_group(&'theme_setter')
	
	update_theme()

func update_theme(curr_key: StringName = &"") -> void:
	var preset = Globals.theme_preset
	
	if not preset:
		return
	
	if curr_key != &"":
		key = curr_key
	
	match key:
		&'white':
			self_modulate = Color.WHITE
		&'light':
			self_modulate = preset.light_color
		&'normal':
			self_modulate = preset.normal_color
		&'dark':
			self_modulate = preset.dark_color
		&'accent':
			self_modulate = preset.accent_text_color
		&'shader':
			print("Updating shader")
			material.set_shader_parameter('outline_color', preset.light_color)
			material.set_shader_parameter('normal_color', preset.normal_color)
			material.set_shader_parameter('shadow_color', preset.dark_color)
