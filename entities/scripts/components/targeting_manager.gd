class_name TargetingManager
extends Node

# --- Signals --- #
signal selected(entity: Entity)
signal targetable_set(value: bool)

# --- Variables --- #
var targetable := false
var is_mouse_over := false

# --- References --- #
@onready var parent := $"../.." as Entity

# --- Functions --- #
func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT:
		return
	if not (event.pressed and is_mouse_over):
		return
	
	select()

func _on_mouse_entered() -> void:
	is_mouse_over = true

func _on_mouse_exited() -> void:
	is_mouse_over = false

func select() -> void:
	selected.emit(parent)

func set_targetable(val: bool) -> void:
	targetable = val
	targetable_set.emit(targetable)
