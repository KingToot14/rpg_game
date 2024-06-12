class_name MainUiPanel
extends Control

# --- Variables --- #
@export var use_mouse: bool = true

# --- Functions --- #
func set_panel_visibility(value: bool, from_mouse := true) -> void:
	if not use_mouse and from_mouse:
		return
	
	visible = value
