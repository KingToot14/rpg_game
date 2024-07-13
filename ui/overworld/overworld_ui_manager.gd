class_name OverworldUiManager
extends CanvasLayer

# --- Variables --- #
@export var chest_panel: ChestUI

var curr_panel

# --- Functions --- #
func _ready() -> void:
	Globals.ui_manager = self
	chest_panel.hide_panel()

func set_panel(panel_name: String) -> void:
	panel_name += "_panel"
	var panel = get_node_or_null(panel_name)
	
	if panel_name == "options_panel":
		panel = OptionsMenu
	
	if not panel:
		return
	
	if curr_panel:
		curr_panel.visible = false
		
		if panel == curr_panel:
			curr_panel = null
			return
	
	curr_panel = panel
	panel.visible = true

func open_chest(items: Array[InventoryItem]) -> void:
	chest_panel.load_items(items)

func save_game() -> void:
	SaveManager.save_game()
	
func load_game():
	DataManager.load_from_save()

func clear_save():
	SaveManager.clear_save()

func reload_file() -> void:
	pass

func quit_game() -> void:
	SceneManager.quit_game()
