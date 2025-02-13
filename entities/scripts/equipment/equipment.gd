class_name Equipment
extends Resource

# --- Variables --- #
@export var equip_name: String
@export_multiline var description: String

@export var equip_texture: Texture2D
@export var equip_backing: Texture2D

var level := 1
@export var enhancements: Array[EquipmentEnhancement] = []

@export var abilities: Array[EquipmentAbility] = []

# --- Functions --- #
func get_description() -> String:
	var out = description
	
	for i in range(level):
		out += "\n- %s" % abilities[i]
	
	return out

func setup_battle(entity: Entity) -> void:
	for i in range(min(level, len(abilities))):
		pass
