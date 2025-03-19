class_name ThemePreset
extends Resource

# --- Enums --- #
enum ColorValue {
	NONE,
	WHITE,
	LIGHT,
	NORMAL,
	SHADED,
	DARK,
	OUTLINE
}

# --- Variables --- #
@export var color_scale: Array[Color]

@export var light_color: Color
@export var normal_color: Color
@export var dark_color: Color

@export var accent_text_color: Color
