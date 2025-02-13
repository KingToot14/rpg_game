class_name EquipmentManager
extends Node

# --- Variables --- #
var parent: Entity

# --- Functions --- #
func setup(entity: Entity) -> void:
	parent = entity
	
	# load current equipment
	PlayerDataChunk
