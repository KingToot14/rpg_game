class_name Attack
extends Resource

# --- Enums --- #
enum TargetSide { PLAYER, ENEMY }
enum TargetingMode { SINGLE, AOE, ALL, RANDOM }
enum DamageType { PHYSICAL, MAGICAL }

# --- Variables --- #
@export var name: String

@export var power: float
@export var side: TargetSide = TargetSide.PLAYER
@export var targeting: TargetingMode = TargetingMode.SINGLE
@export var damage_type: DamageType = DamageType.PHYSICAL
@export var accuracy: float = 100
@export var crit_rate: float = 10
@export var randomness: float = 10

# --- Functions --- #
func calculate_damage(attacker: Entity, target: Entity):
	# Formula: (Power * Attack/Defense) * TODO: Elemental Mod
	var use_magic = damage_type == DamageType.MAGICAL
	var dmg = power * (attacker.get_attack(use_magic) / target.get_defense(use_magic))
	dmg *= randf_range(100 - randomness / 2, 100 + randomness / 2) / 100
	
	return dmg
