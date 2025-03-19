class_name OverworldButton
extends BaseButton

# --- Variables --- #
# @@show_if(not use_textures)
@export var outline_rect: ThemeSetter
# @@show_if(use_textures)
@export var texture_rect: TextureRect

@export var use_textures := false

# @@show_if(not use_textures)
@export var normal_key := ThemePreset.ColorValue.NORMAL
# @@show_if(not use_textures)
@export var hover_key := ThemePreset.ColorValue.LIGHT
# @@show_if(use_textures)
@export var normal_texture: Texture2D
# @@show_if(use_textures)
@export var hover_texture: Texture2D

@export var use_alternate: bool = false
# @@show_if(not use_textures)
@export var alt_normal_key := ThemePreset.ColorValue.DARK
# @@show_if(not use_textures)
@export var alt_hover_key := ThemePreset.ColorValue.NORMAL
# @@show_if(use_textures)
@export var alt_normal_texture: Texture2D
# @@show_if(use_textures)
@export var alt_hover_texture: Texture2D

# --- Functions --- #
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	set_hover()

func _on_mouse_exited() -> void:
	set_normal()

func set_alternate(value: bool) -> void:
	use_alternate = value
	
	set_normal()

func set_hover() -> void:
	if use_alternate:
		if use_textures:
			texture_rect.texture = alt_hover_texture
		else:
			outline_rect.update_theme(alt_hover_key)
	else:
		if use_textures:
			texture_rect.texture = hover_texture
		else:
			outline_rect.update_theme(hover_key)

func set_normal() -> void:
	if use_alternate:
		if use_textures:
			texture_rect.texture = alt_normal_texture
		else:
			outline_rect.update_theme(alt_normal_key)
	else:
		if use_textures:
			texture_rect.texture = normal_texture
		else:
			outline_rect.update_theme(normal_key)
