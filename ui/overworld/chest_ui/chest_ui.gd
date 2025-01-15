class_name ChestUI
extends Control

# --- Variables --- #
@export var item_rows: Array[Control] = []
@export var slot_rows: Array[Control] = []

# --- Functions --- #
func load_items(items: Array[InventoryItem]) -> void:
	show_panel()
	
	# set items
	var index := 0
	
	for row in item_rows:
		row.visible = index < len(items)
		
		for child in row.get_children():
			child.visible = index < len(items)
			slot_rows[floori(index / 5.0)].get_child(index % 5).visible = index < len(items)
			
			if child.visible:
				child.set_item(items[index])
			
			index += 1

func show_panel() -> void:
	visible = true

func hide_panel() -> void:
	visible = false
