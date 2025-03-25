class_name ItemMenu
extends ActionMenu

# --- Variables --- #


# --- Functions --- #
func _ready() -> void:
	# load items
	var index = 0
	var items: Array[ItemDataChunk] = DataManager.get_inventory(&'item')
	
	for row in $'grid'.get_children():
		row.visible = index < len(items)
		
		for child: ActionMenuItem in row.get_children():
			# skip standard items
			while index < len(items) and not items[index].in_battle:
				index += 1
			
			if index < len(items):
				child.set_menu_item(items[index])
			else:
				child.set_menu_item(null)
			
			index += 1
	
	super()
