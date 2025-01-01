class_name MainUiPanel
extends Control

# --- Variables --- #
@export var use_mouse: bool = true
@export var mouse_threshold: float

@export var tween_time := 0.25
@export var tween_offset := 8.0
var origin: float

# --- Functions --- #
func _ready() -> void:
	origin = position.y
	modulate.a = 0.0

func _input(event):
	if not use_mouse or not event is InputEventMouseMotion:
		return
	
	if modulate.a > 0.0 and event.position.y < get_parent().global_position.y:
		set_panel_visibility(false)
	elif modulate.a < 0.1 and event.position.y > get_parent().global_position.y:
		set_panel_visibility(true)

func set_panel_visibility(value: bool, from_mouse := true) -> void:
	if not use_mouse and from_mouse:
		return
	
	var tween = create_tween().set_parallel()
	
	if value:
		tween.tween_property(self, 'modulate:a', 1.0, tween_time)
		tween.tween_property(self, 'position:y', origin, tween_time)
	else:
		tween.tween_property(self, 'modulate:a', 0.0, tween_time)
		tween.tween_property(self, 'position:y', origin + tween_offset, tween_time)
