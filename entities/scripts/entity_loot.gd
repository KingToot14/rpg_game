class_name EntityLoot
extends Resource

# --- Variables --- #
@export var item_key: StringName
@export var min_count: int
@export var max_count: int

# --- Functions --- #
func get_item() -> InventoryItem:
	return InventoryItem.new(item_key, clamp(randi_range(min_count, max_count), 0, max_count))
