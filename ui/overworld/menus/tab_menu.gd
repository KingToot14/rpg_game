class_name TabMenu
extends Control

# --- Variables --- #
@export var tab_parent: Control
@export var content_parent: Control

# --- Functions --- #
func _ready() -> void:
	if not content_parent:
		content_parent = self

func set_tab(tab_name: String) -> void:
	tab_name += "_tab"
	
	if not content_parent.has_node(tab_name):
		return
	
	# update tab
	for child in content_parent.get_children():
		if not child.name.ends_with('_tab'):
			continue
		child.visible = child.name == tab_name
	
	# update button
	if not tab_parent.has_node(tab_name):
		return
	
	for child in tab_parent.get_children():
		child.set_alternate(child.name != tab_name)
