class_name Equipment
extends Resource

# --- Variables --- #
@export var equip_name: String
@export_multiline var description: String

@export var equip_texture: Texture2D
@export var equip_backing: Texture2D

@export_group("Battle")
var level := 1
@export var enhancements: Array[EquipmentEnhancement] = []
@export var abilities: Array[EquipmentAbility] = []

@export var element: Attack.Element = Attack.Element.NONE
@export var element_percent := 0.50

# --- Functions --- #
func get_description() -> String:
	var out = description
	
	for i in range(level):
		out += "\n- %s" % abilities[i]
	
	return out

func setup_battle(entity: Entity) -> void:
	if not entity:
		return
	
	for i in range(len(abilities)):
		if abilities[i]:
			abilities[i].setup(entity, level)

func remove_signals() -> void:
	for i in range(len(abilities)):
		if abilities[i]:
			abilities[i].remove_signals()
