class_name OverworldButton
extends BaseButton

# --- Variables --- #

# --- References --- #
@onready var backing := $"backing" as Control

# --- Functions --- #
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	var tween = create_tween()
	
	tween.tween_property(backing, 'modulate:a', 1.0, 0.15)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	
	tween.tween_property(backing, 'modulate:a', 0.0, 0.15)

func quit_game() -> void:
	SceneManager.quit_game()
