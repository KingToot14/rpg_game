class_name AttackManager
extends Node2D

# --- Functions --- #
func _ready() -> void:
	Globals.attack_manager = self

func setup_attack() -> bool:
	var anim_name = Globals.curr_item.animation_name
	
	if not Globals.curr_entity.contains_attack(anim_name):
		return false
	
	Globals.timing_mods = []
	
	if Globals.curr_entity.is_player:
		Globals.ui_manager.show_timing(&"single_hit", Globals.curr_entity.get_timed_inputs(anim_name))
	
	Globals.curr_entity.perform_attack(anim_name)
	
	return true

func do_damage(target, modifier: float = 1.0) -> void:
	var attack = Globals.curr_item as Attack
	var dmg = round(attack.calculate_damage(Globals.curr_entity, target))
	
	if len(Globals.timing_mods) > 0:
		dmg *= Globals.timing_mods[0]
	
	dmg *= modifier
	
	# set target
	target.take_damage(dmg)
	
	if attack.targeting == Attack.TargetingMode.AOE:
		var group = &'player'
		
		if attack.side == Attack.TargetSide.ENEMY:
			group = &'enemy'
		
		var neighbors = TargetingHelper.get_neighbors(target.spawn_index, group)
		
		for neighbor in neighbors:
			neighbor.take_damage(dmg * 0.5)
	
