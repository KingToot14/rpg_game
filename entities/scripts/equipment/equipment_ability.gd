class_name EquipmentAbility
extends Resource

# --- Variables --- #
var entity

@export_range(1, 3, 1) var level_requirement := 1
var level := 0

# --- Functions --- #
func setup(new_entity: Entity, new_level: int) -> void:
	entity = new_entity
	level = new_level
