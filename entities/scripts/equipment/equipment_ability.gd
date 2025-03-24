class_name EquipmentAbility
extends Resource

# --- Variables --- #
var entity: Entity

@export_range(0, 3, 1) var level_requirement := 1
@export_range(0, 3, 1) var maximum_level := 3
var level := 0

# --- Functions --- #
func setup(new_entity: Entity, new_level: int) -> void:
	if new_level < level_requirement or new_level > maximum_level:
		return
	
	entity = new_entity
	level = new_level
	
	setup_signals()

func setup_signals() -> void:
	pass

func remove_signals() -> void:
	pass
