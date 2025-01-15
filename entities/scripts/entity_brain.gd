class_name EntityBrain
extends Node

# --- Variables --- #
@export var action_delay: float = 0.5

var action: ActionResource
var selected_target: Entity

# --- References --- #
@onready var parent := $"../.." as Entity

const PERF_MOD := 1.15
const GOOD_MOD := 1.00
const POOR_MOD := 0.90

# --- Functions --- #
func _on_turn_started() -> void:
	return

func _on_action_selected(new_action: ActionResource) -> void:
	if not parent.turn.taking_turn:
		return
	
	action = new_action

func _on_entity_selected(entity: Entity) -> void:
	if not parent.turn.taking_turn:
		return
	
	selected_target = entity

func perform_action() -> void:
	parent.turn.actions_remaining -= 1
	action.start_cooldown()
	parent.animator.play_action_anim(action.animation_name)

func do_damage(target: Entity, damage_mod := 1.0) -> void:
	var attack := action as Attack
	
	var dmg_chunk := attack.calculate_damage(parent, target) as DamageChunk
	
	#TODO: Implement timing modifiers
	if parent.is_player() and len(Globals.timing_mods) > 0:
		var timing_mod = Globals.timing_mods.pop_front()
		
		if timing_mod == &'perf':
			dmg_chunk.damage *= PERF_MOD
		elif timing_mod == &'good':
			dmg_chunk.damage *= GOOD_MOD
		else:
			dmg_chunk.damage *= POOR_MOD
	
	dmg_chunk.damage *= damage_mod
	
	# set target
	target.hp.take_damage(dmg_chunk)
