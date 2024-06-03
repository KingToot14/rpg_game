class_name AttackManager
extends Node2D

# --- Variables --- #


# --- Functions --- #
func _ready() -> void:
	Globals.attack_manager = self

func setup_attack() -> void:
	Globals.timing_mods = []
	
	if Globals.curr_entity.is_player:
		Globals.ui_manager.show_timing(&"single_hit", Globals.curr_entity.get_timed_inputs(&'test'))
		print(Globals.curr_entity.get_timed_inputs(&'test'))
	
	Globals.curr_entity.perform_attack(&'test')

func do_damage() -> void:
	var attack = Globals.curr_item as Attack
	var dmg = round(attack.calculate_damage(Globals.curr_entity, Globals.curr_targets[0]))
	
	if len(Globals.timing_mods) > 0:
		dmg *= Globals.timing_mods.pop_front()
	
	Globals.curr_targets[0].take_damage(dmg)
