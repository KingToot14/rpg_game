class_name EntityBrain
extends Node

# --- Variables --- #
@export var action_delay: float = 0.5

var action: ActionResource
var selected_target: Entity

# --- References --- #
@onready var parent := $"../.." as Entity

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

func do_damage(target: Entity, damage_mod := 1.0) -> void:
	var attack := action as Attack
	
	var dmg_chunk := attack.calculate_damage(parent, target) as DamageChunk
	
	#TODO: Implement timing modifiers
	
	dmg_chunk.damage *= damage_mod
	
	# set target
	target.hp.take_damage(dmg_chunk)
