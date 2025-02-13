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
	var params = {}
	params['stat'] = stats.get_max_hp(parent.level)
	
	parent.getting_stat.emit(Globals.Stat.HEALTH, params)
	
	return params['stat']
	
	#var max_hp = stats.get_max_hp(parent.level)
	#
	#for effect in parent.status_effects.status_effects:
		#max_hp = effect.get_max_hp(max_hp)
	#
	#return max_hp

func get_attack(use_magic: bool) -> float:
	var params = {}
	params['stat'] = stats.get_m_attack(parent.level) if use_magic else stats.get_p_attack(parent.level)
	
	parent.getting_stat.emit(Globals.Stat.M_ATTACK if use_magic else Globals.Stat.P_ATTACK, params)
	
	#for effect in parent.status_effects.status_effects:
		#if use_magic:
			#attack = effect.get_m_attack(attack)
		#else:
			#attack = effect.get_p_attack(attack)
	
	return params['stat']

func get_defense(use_magic: bool) -> float:
	var params = {}
	params['stat'] = stats.get_m_defense(parent.level) if use_magic else stats.get_p_defense(parent.level)
	
	parent.getting_stat.emit(Globals.Stat.M_DEFENSE if use_magic else Globals.Stat.P_DEFENSE, params)
	
	return params['stat']
	
	#var defense = stats.get_m_defense(parent.level) if use_magic else stats.get_p_defense(parent.level)
	#
	#for effect in parent.status_effects.status_effects:
		#if use_magic:
			#defense = effect.get_m_defense(defense)
		#else:
			#defense = effect.get_p_defense(defense)
	#
	#return defense

func get_accuracy() -> float:
	var params = {}
	params['stat'] = stats.get_accuracy(parent.level)
	
	parent.getting_stat.emit(Globals.Stat.ACCURACY, params)
	
	return params['stat']
	
	#var accuracy = stats.get_accuracy(parent.level)
	#
	#for effect in parent.status_effects.status_effects:
		#accuracy = effect.get_accuracy(accuracy)
	#
	#return accuracy

func get_evasion() -> float:
	var params = {}
	params['stat'] = stats.get_evasion(parent.level)
	
	parent.getting_stat.emit(Globals.Stat.EVASION, params)
	
	return params['stat']
	
	#var evasion = stats.get_evasion(parent.level)
	#
	#for effect in parent.status_effects.status_effects:
		#evasion = effect.get_evasion(evasion)
	#
	#return evasion

func get_resistance(resistance: Attack.Element) -> float:
	var mod := 0.0
	
	if resistance in stats.resistances:
		mod = stats.resistances[resistance]
	
	#for effect in parent.status_effects.status_effects:
		#mod = effect.get_resistance(resistance, mod)
	
	return mod
