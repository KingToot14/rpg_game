class_name OverworldUiManager
extends CanvasLayer

# --- Variables --- #
@export var chest_panel: ChestUI

# --- Functions --- #
func _ready() -> void:
	Globals.ui_manager = self
	chest_panel.hide_panel()

func open_chest(items: Array[InventoryItem]) -> void:
	chest_panel.load_items(items)
