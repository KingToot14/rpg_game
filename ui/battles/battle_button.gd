class_name BattleButton
extends BaseButton

# --- Variables --- #
@export var tween_time := 0.10

# --- References --- #
@onready var backing_rect := $"backing" as NinePatchRect

# --- Functions --- #
func _on_mouse_entered():
	var tween = create_tween()
	
	tween.tween_property(backing_rect, 'modulate:a', 1.0, tween_time)

func _on_mouse_exited():
	var tween = create_tween()
	
	tween.tween_property(backing_rect, 'modulate:a', 0.0, tween_time)
