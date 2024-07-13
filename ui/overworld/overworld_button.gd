class_name OverworldButton
extends BaseButton

# --- Variables --- #
@export var outline_rect: ThemeSetter

@export var normal_key: StringName = &'normal'
@export var hover_key: StringName = &'light'

@export var use_alternate: bool = false
@export var alt_normal_key: StringName = &'dark'
@export var alt_hover_key: StringName = &'normal'

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
		outline_rect.update_theme(alt_hover_key)
	else:
		outline_rect.update_theme(hover_key)

func set_normal() -> void:
	if use_alternate:
		outline_rect.update_theme(alt_normal_key)
	else:
		outline_rect.update_theme(normal_key)
