class_name Attack
extends ActionResource

# --- Enums --- #
enum DamageType { PHYSICAL, MAGICAL }

enum TimingType { TIMED_INPUT, MASH }
enum Element {
	EMPTY = 0,
	NONE = 1, USE_WEAPON = 2,
	FIRE = 4,    ELECTRIC = 8, NATURE = 16,
	WATER = 32,  ICE = 64,     FLYING = 128,
	EARTH = 256, LIGHT = 512,  DARK = 1024
}

# --- Variables --- #
@export var power: float
@export var element: Element = Element.NONE
# @@show_if(element != Element.NONE)
@export var element_percent: float
@export var damage_type: DamageType = DamageType.PHYSICAL
@export var timing_type: TimingType = TimingType.TIMED_INPUT
@export var accuracy: float = 1
@export var crit_rate: float = .10
@export var randomness: float = .10

# --- Functions --- #
func calculate_damage(attacker: Entity, target: Entity) -> Dictionary:
	var dmg_chunk := {
		&'damage': 0,
		&'element': element,
		&'element_percent': element_percent,
		&'source': &'entity'
	}
	
	# Formula: (Power * Attack/Defense) * Elemental Mod
	var use_magic = damage_type == DamageType.MAGICAL
	
	# base damage
	dmg_chunk[&'damage'] = power * (attacker.stats.get_attack(use_magic) / target.stats.get_defense(use_magic))
	
	# elemental mod
	dmg_chunk[&'damage'] *= (1.0 - element_percent) + (element_percent * (1.0 - target.stats.get_resistance(element)))
	
	# randomizer
	dmg_chunk[&'damage'] *= randf_range(1.0 - randomness / 2, 1.0 + randomness / 2)
	
	return dmg_chunk
