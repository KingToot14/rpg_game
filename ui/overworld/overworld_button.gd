class_name OverworldButton
extends BaseButton

# --- Variables --- #
@export var outline_rect: ThemeSetter

@export var normal_key: StringName = &'normal'
@export var hover_key: StringName = &'light'

# --- Functions --- #
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	outline_rect.update_theme(hover_key)

func _on_mouse_exited() -> void:
	outline_rect.update_theme(normal_key)

func quit_game() -> void:
	SceneManager.quit_game()
