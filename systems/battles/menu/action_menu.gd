class_name ActionMenu
extends Control

# --- Signals --- #
signal item_selected(item: Resource)

# --- Functions --- #
func set_item(item: Resource) -> void:
	item_selected.emit(item)
