class_name LootManager
extends Node

# --- Variables --- #
@export var loot: Array[EntityLoot] = []

# --- Functions --- #
func add_loot() -> void:
	var items: Array[InventoryItem] = []
	
	for item in loot:
		items.append(item.get_item())
	
	Globals.encounter_manager.add_items(items)
