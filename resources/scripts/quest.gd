class_name Quest
extends Resource

# --- Variables --- #
@export var requirements: Array[InventoryItem] = []
@export var reward: Array[InventoryItem] = []

# --- Functions --- #
func pay_and_collect() -> void:
	# pay
	for item in requirements:
		DataManager.remove_from_inventory(item)
	
	# collect
	for item in reward:
		DataManager.add_to_inventory(item)
