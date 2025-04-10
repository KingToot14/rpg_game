class_name LootManager
extends Node

# --- Variables --- #
@export var xp_reward := 5
@export var loot: Array[EntityLoot] = []

# --- Functions --- #
func setup(entity: Entity) -> void:
	entity.hp.died.connect(_on_death)

func _on_death() -> void:
	add_xp()
	add_loot()

func add_xp() -> void:
	Globals.encounter_manager.add_xp(xp_reward)

func add_loot() -> void:
	# loot
	var items: Array[InventoryItem] = []
	
	for item in loot:
		items.append(item.get_item())
	
	Globals.encounter_manager.add_items(items)
