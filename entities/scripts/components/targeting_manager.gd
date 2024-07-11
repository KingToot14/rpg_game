class_name TargetingManager
extends Node

# --- Signals --- #
signal selected(entity: Entity)
signal targetable_set(value: bool)

# --- Variables --- #
@export var dont_show_if_targeting := false

var targetable := false
var is_mouse_over := false

# --- References --- #
var parent: Entity

# --- Functions --- #
func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT:
		return
	if not (event.pressed and is_mouse_over):
		return
	
	select()

func setup(entity: Entity) -> void:
	parent = entity

func _on_mouse_entered() -> void:
	is_mouse_over = true
	
	show_info()

func _on_mouse_exited() -> void:
	is_mouse_over = false
	
	hide_info()

func select() -> void:
	selected.emit(parent)

func set_targetable(val: bool) -> void:
	targetable = val
	targetable_set.emit(targetable)

func show_info() -> void:
	Globals.ui_manager.entity_info_panel.show_entity(parent)

func hide_info() -> void:
	Globals.ui_manager.entity_info_panel.hide_info()
