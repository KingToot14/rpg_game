class_name Attack
extends ActionResource

# --- Enums --- #
enum TargetSide { PLAYER, ENEMY }
enum TargetingMode { SINGLE, AOE, ALL, RANDOM }
enum DamageType { PHYSICAL, MAGICAL }

enum TimingType { TIMED_INPUT, MASH }

enum Element {
	NONE, USE_WEAPON,
	FIRE, ELECTRIC, NATURE,
	WATER, ICE, FLYING,
	EARTH, LIGHT, DARK
}

# --- Variables --- #
@export var power: float
@export var element: Element
# @@show_if(element != Element.NONE)
@export var element_percent: float
@export var side: TargetSide = TargetSide.PLAYER
@export var targeting: TargetingMode = TargetingMode.SINGLE
# @@show_if(targeting == TargetingMode.AOE)
@export var aoe_modifier := 0.5
@export var damage_type: DamageType = DamageType.PHYSICAL
@export var timing_type: TimingType = TimingType.TIMED_INPUT
@export var accuracy: float = 1
@export var crit_rate: float = .10
@export var randomness: float = .10

# --- Functions --- #
func calculate_damage(attacker: Entity, target: Entity) -> DamageChunk:
	# Formula: (Power * Attack/Defense) * Elemental Mod
	var use_magic = damage_type == DamageType.MAGICAL
	
	# base damage
	var dmg = power * (attacker.stats.get_attack(use_magic) / target.stats.get_defense(use_magic))
	
	# elemental mod
	dmg *= (1.0 - element_percent) + (element_percent * (1.0 - target.stats.get_resistance(element)))
	
	# randomizer
	dmg *= randf_range(1.0 - randomness / 2, 1.0 + randomness / 2)
	
	return DamageChunk.new(dmg, element, element_percent)

func can_target(target: Entity) -> bool:
	if side & TargetSide.ENEMY:
		return not target.is_player()
	if side & TargetSide.PLAYER:
		return target.is_player()
	
	return false

func highlight_targets() -> void:
	if side & TargetSide.ENEMY:
		var enemies = TargetingHelper.get_entities(&'enemy')
		
		for enemy in enemies:
			enemy.targeting.set_targetable(true)
	if side & TargetSide.PLAYER:
		var players = TargetingHelper.get_entities(&'player')
		
		for player in players:
			player.targeting.set_targetable(true)

func start_cooldown(val: int = -1) -> void:
	if val < 0:
		if cooldown > 0:
			val = cooldown + 1
		else:
			val = 0
	
	remaining_cooldown = val

func decrement_cooldown() -> void:
	remaining_cooldown = max(remaining_cooldown - 1, 0)
