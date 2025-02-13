class_name EntityStats
extends Resource

# --- Variables --- #
@export var max_hp := 50
@export var p_attack := 4.0
@export var m_attack := 4.0
@export var p_defense := 4.0
@export var m_defense := 4.0
@export var accuracy := 3.0
@export var evasion := 3.0

@export var resistances = {}

@export var new_element: Attack.Element = 0 
# @@buttons("Add Resistance", add_resistance())
@export var new_mod: float

# --- Constants --- #
const HP_LEVEL_UP = 1.20
const P_ATTACK_LEVEL_UP = 1.20
const M_ATTACK_LEVEL_UP = 1.2
const P_DEFENSE_LEVEL_UP = 1.20
const M_DEFENSE_LEVEL_UP = 1.20
const ACCURACY_LEVEL_UP = 1.20
const EVASION_LEVEL_UP = 1.20

# --- Functions --- #
func add_resistance() -> void:
	if new_element == Attack.Element.NONE or new_element == Attack.Element.USE_WEAPON:
		printerr("Cannot add \'None\' or \'Use_Weapon\' to resistances")
		return
	
	if len(resistances) == 0:
		resistances = {new_element: new_mod}
	else:
		resistances[new_element] = new_mod

func get_max_hp(level: int = 1) -> int:
	return round(max_hp * (HP_LEVEL_UP ** (level - 1)))

func get_p_attack(level: int = 1) -> float:
	return p_attack * (P_ATTACK_LEVEL_UP ** (level - 1))

func get_m_attack(level: int = 1) -> float:
	return m_attack * (M_ATTACK_LEVEL_UP ** (level - 1))

func get_p_defense(level: int = 1) -> float:
	return p_defense * (P_DEFENSE_LEVEL_UP ** (level - 1))

func get_m_defense(level: int = 1) -> float:
	return m_defense * (M_DEFENSE_LEVEL_UP ** (level - 1))

func get_accuracy(level: int = 1) -> float:
	return accuracy * (ACCURACY_LEVEL_UP ** (level - 1))

func get_evasion(level: int = 1) -> float:
	return evasion * (EVASION_LEVEL_UP ** (level - 1))
