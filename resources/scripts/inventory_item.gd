class_name InventoryItem
extends Resource

# --- Variables --- #
@export var item_key: StringName
@export var quantity: int = 1
@export var inventory: StringName

# --- Functions --- #
func _init(key: StringName = &"no_name", quant: int = 1, inv: StringName = &"item") -> void:
	item_key = key
	quantity = quant
	inventory = inv
