class_name OverworldUiManager
extends CanvasLayer

# --- Variables --- #
@export var chest_panel: ChestUI

var curr_panel: Control

# --- Functions --- #
func _ready() -> void:
	Globals.ui_manager = self
	chest_panel.hide_panel()

func set_panel(panel_name: String) -> void:
	panel_name += "_panel"
	var panel = get_node_or_null(panel_name)
	
	if not panel:
		return
	
	if curr_panel:
		curr_panel.visible = false
		
		if panel_name == curr_panel.name:
			curr_panel = null
			return
	
	curr_panel = panel
	panel.visible = true

func open_chest(items: Array[InventoryItem]) -> void:
	chest_panel.load_items(items)
