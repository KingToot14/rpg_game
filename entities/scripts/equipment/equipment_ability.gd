class_name EquipmentAbility
extends Resource

# --- Variables --- #
var entity: Entity

@export_range(0, 3, 1) var level_requirement := 1
var level := 0

# --- Functions --- #
func setup(new_entity: Entity, new_level: int) -> void:
	entity = new_entity
	level = new_level
