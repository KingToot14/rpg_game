class_name Attack
extends Resource

# --- Enums --- #
enum TargetSide { PLAYER, ENEMY }
enum TargetingMode { SINGLE, AOE, ALL, RANDOM }
enum DamageType { PHYSICAL, MAGICAL }

enum Element {
	NONE, USE_WEAPON,
	FIRE, ELECTRIC, NATURE,
	WATER, ICE, FLYING,
	EARTH, LIGHT, DARK
}

# --- Variables --- #
@export var name: String
@export var animation_name: StringName
@export var icon: Texture2D

@export_multiline var description: String

@export var power: float
@export var element: Element
# @@show_if(element != Element.NONE)
@export var element_percent: float
@export var side: TargetSide = TargetSide.PLAYER
@export var targeting: TargetingMode = TargetingMode.SINGLE
@export var damage_type: DamageType = DamageType.PHYSICAL
@export var accuracy: float = 100
@export var crit_rate: float = 10
@export var randomness: float = 10

# --- Functions --- #
func calculate_damage(attacker: Entity, target: Entity) -> float:
	# Formula: (Power * Attack/Defense) * TODO: Elemental Mod
	var use_magic = damage_type == DamageType.MAGICAL
	
	# base damage
	var dmg = power * (attacker.get_attack(use_magic) / target.get_defense(use_magic))
	
	# elemental mod
	dmg *= (1.0 - element_percent) + (element_percent * (1.0 - target.get_resistance(element)))
	
	# randomizer
	dmg *= randf_range(100 - randomness / 2, 100 + randomness / 2) / 100
	
	return dmg

func highlight_targets() -> void:
	if side == TargetSide.ENEMY:
		var enemies = TargetingHelper.get_entities(&'enemy')
		
		for enemy in enemies:
			enemy.set_targetable(true)
