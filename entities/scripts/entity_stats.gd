class_name EntityStats
extends Resource

# --- Variables --- #
@export var max_hp: int
@export var p_attack: float
@export var p_defense: float
@export var m_attack: float
@export var m_defense: float
@export var accuracy: float
@export var evasion: float

@export var resistances = {}

@export var new_element: Attack.Element
# @@buttons("Add Resistance", add_resistance())
@export var new_mod: float

# --- Functions --- #
func add_resistance() -> void:
	if new_element == Attack.Element.NONE or new_element == Attack.Element.USE_WEAPON:
		printerr("Cannot add \'None\' or \'Use_Weapon\' to resistances")
		return
	
	if len(resistances) == 0:
		resistances = {new_element: new_mod}
	else:
		resistances[new_element] = new_mod
