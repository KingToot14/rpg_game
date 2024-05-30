class_name Attack
extends Resource

# --- Enums --- #
enum TargetingMode { SINGLE, AOE, ALL, RANDOM }
enum DamageType { PHYSICAL, MAGICAL }

# --- Variables --- #
@export var name: String

@export var power: float
@export var targeting: TargetingMode = TargetingMode.SINGLE
@export var damage_type: DamageType = DamageType.PHYSICAL
@export var accuracy: float = 100
@export var crit_rate: float = 10
@export var randomness: float = 10

# --- Functions --- #

