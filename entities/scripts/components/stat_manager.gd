class_name StatManager
extends Node

# --- Variables --- #
@export var stats: EntityStats

# --- References --- #
var parent: Entity

# --- Functions --- #
func setup(entity: Entity) -> void:
	parent = entity

func get_max_hp() -> float:
	var max_hp = stats.max_hp
	
	for effect in parent.status_effects.status_effects:
		max_hp = effect.get_max_hp(max_hp)
	
	return max_hp

func get_attack(use_magic: bool) -> float:
	var attack = stats.m_attack if use_magic else stats.p_attack
	
	for effect in parent.status_effects.status_effects:
		if use_magic:
			attack = effect.get_m_attack(attack)
		else:
			attack = effect.get_p_attack(attack)
	
	return attack

func get_defense(use_magic: bool) -> float:
	var defense = stats.m_defense if use_magic else stats.p_defense
	
	for effect in parent.status_effects.status_effects:
		if use_magic:
			defense = effect.get_m_defense(defense)
		else:
			defense = effect.get_p_defense(defense)
	
	return defense

func get_accuracy() -> float:
	var accuracy = stats.accuracy
	
	for effect in parent.status_effects.status_effects:
		accuracy = effect.get_accuracy(accuracy)
	
	return accuracy

func get_evasion() -> float:
	var evasion = stats.max_hp
	
	for effect in parent.status_effects.status_effects:
		evasion = effect.get_evasion(evasion)
	
	return evasion

func get_resistance(resistance: Attack.Element) -> float:
	var mod := 0.0
	
	if resistance in stats.resistances:
		mod = stats.resistances[resistance]
	
	for effect in parent.status_effects.status_effects:
		mod = effect.get_resistance(resistance, mod)
	
	return mod
