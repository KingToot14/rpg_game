class_name AttackManager
extends Node2D

# --- References --- #
const POOR_MULT := 0.90
const GOOD_MULT := 1.00
const PERF_MULT := 1.20

# --- Functions --- #
func _ready() -> void:
	Globals.attack_manager = self

func setup_attack() -> bool:
	var anim_name = Globals.curr_item.animation_name
	
	Globals.timing_mods = []
	
	if Globals.curr_entity.is_player:
		Globals.ui_manager.enable_timing()
	
	Globals.curr_entity.animator.play_action_anim(anim_name)
	Globals.curr_item.start_cooldown() 
	
	return true

func setup_defense() -> bool:
	var anim_name = Globals.curr_item.animation_name
	
	Globals.curr_entity.animator.play_action_anim(anim_name)
	Globals.curr_item.start_cooldown()
	
	return true

func do_damage(target, modifier: float = 1.0) -> void:
	var attack = Globals.curr_item as Attack
	var dmg = round(attack.calculate_damage(Globals.curr_entity, target))
	
	if len(Globals.timing_mods) > 0:
		var mod = Globals.timing_mods[0]
		match mod:
			&'poor':
				dmg *= POOR_MULT
			&'good':
				dmg *= GOOD_MULT
			&'perfect':
				dmg *= PERF_MULT
	
	dmg *= modifier
	
	# set target
	target.hp.take_damage(dmg)
	
	if attack.targeting == Attack.TargetingMode.AOE:
		var group = &'player'
		
		if attack.side == Attack.TargetSide.ENEMY:
			group = &'enemy'
		
		var neighbors = TargetingHelper.get_neighbors(target.spawn_index, group)
		
		for neighbor in neighbors:
			neighbor.hp.take_damage(dmg * 0.5)
