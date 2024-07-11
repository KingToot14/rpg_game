extends CanvasLayer

# --- Variables --- #
@export var pixel_cursor: Texture2D

# --- Functions --- #
func _ready() -> void:
	visible = false
	
	set_mouse_cursor(&'pixel')
	resize_cursor()
	
	get_tree().get_root().size_changed.connect(resize_cursor)

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

func set_mouse_cursor(value: StringName) -> void:
	match value:
		&'normal':
			pass
		&'pixel':
			var image = pixel_cursor.get_image()
			image.resize(27, 27, Image.INTERPOLATE_NEAREST)
			Input.set_custom_mouse_cursor(ImageTexture.create_from_image(image))

func resize_cursor() -> void:
	var size = get_viewport().size
	var viewport_scale = min(size.x / 480.0, size.y / 270.0)
	
	var image = pixel_cursor.get_image()
	image.resize(9 * viewport_scale, 9 * viewport_scale, Image.INTERPOLATE_NEAREST)
	Input.set_custom_mouse_cursor(ImageTexture.create_from_image(image))

#endregion
