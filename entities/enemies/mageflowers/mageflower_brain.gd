class_name MageflowerBrain
extends EntityBrain

# --- Variables --- #
@export var status_elemental_key: StringName
@export var status_effect_key: StringName

@export var normal_elemental_key: StringName
@export var ultimate_elemental_key: StringName

# --- Functions --- #
func perform_turn() -> void:
	# always attack
	Globals.action_fsm.set_state('attack')
	
	# get target
	var target = TargetingHelper.get_random_entity(&'player')
	
	# - attack logic
	
	# perform ultimate if charged
	if parent.status_effects.has_effect(&'charge'):
		Globals.curr_item = parent.actions.get_attack(ultimate_elemental_key)
		target.targeting.select()
		return
	
	var pool: Array[Attack] = [parent.actions.get_attack(normal_elemental_key)]
	
	# only allow status attack if target is not already inflicted
	if not target.status_effects.has_effect(status_effect_key):
		pool.append(parent.actions.get_attack(status_elemental_key))
	
	Globals.curr_item = pool.pick_random()
	
	# select target
	target.targeting.select()
