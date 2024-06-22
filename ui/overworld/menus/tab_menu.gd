class_name TabMenu
extends Control

# --- Variables --- #


# --- Functions --- #
func set_tab(tab_name: String) -> void:
	if not has_node(tab_name + "_tab"):
		return
	
	for child in get_children():
		if not '_tab' in child.name:
			continue
		child.visible = child.name == tab_name + "_tab"
