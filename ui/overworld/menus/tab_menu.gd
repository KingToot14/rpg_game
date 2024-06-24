class_name TabMenu
extends Control

# --- Variables --- #
@export var tab_parent: Control

# --- Functions --- #
func set_tab(tab_name: String) -> void:
	tab_name += "_tab"
	
	if not has_node(tab_name):
		return
	
	# update tab
	for child in get_children():
		if not '_tab' in child.name:
			continue
		child.visible = child.name == tab_name
	
	# update button
	if not tab_parent.has_node(tab_name):
		return
	
	for child in tab_parent.get_children():
		child.set_alternate(child.name != tab_name)
