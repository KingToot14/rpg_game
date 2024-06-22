class_name InventoryDisplay
extends Control

# --- Variables --- #
@export var key: StringName

# --- Functions --- #
func load_inventory() -> void:
	var items = DataManager.get_inventory(key)
	var rows = get_children()
	var index := 0
	
	for row in rows:
		for child: ItemInfo in row.get_children():
			if index < len(items):
				child.set_item(items[index])
			else:
				child.set_item(null)
			
			index += 1
