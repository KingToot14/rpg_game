class_name EquipmentEnhancement
extends Resource

# --- Variables --- #
@export var requirements: Array[InventoryItem] = []

# --- Functions --- #
func meets_requirements() -> bool:
	return DataManager.has_item_list(requirements)

func accept_enhancement() -> void:
	for item in requirements:
		DataManager.remove_from_inventory(item)
