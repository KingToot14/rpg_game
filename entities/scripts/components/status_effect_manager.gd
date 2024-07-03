class_name StatusEffectManager
extends Node

# --- Signals --- #
signal effect_added()

# --- Variables --- #
var status_effects = {}
var removal_queue: Array[StringName] = []

# --- References --- #
var parent: Entity

# --- Functions --- #
func setup(entity: Entity) -> void:
	parent = entity

func _on_turn_started() -> void:
	for effect in get_effects():
		effect.turn_started()
	
	remove_effects()

func _on_turn_ended() -> void:
	for effect in get_effects():
		effect.turn_ended()
	
	remove_effects()

func get_effects():
	return status_effects.values()

func add_effect(key: StringName, stacks := 1, stage := 1) -> void:
	if key in status_effects:
		status_effects[key].add_stacks(stacks, stage)
	else:
		status_effects[key] = Globals.registered_effects[key].new(parent, stacks, stage)
	
	effect_added.emit()

func has_effect(key: StringName, min_stacks := 0, min_stage := 0) -> bool:
	if not key in status_effects:
		return false
	
	var effect = status_effects[key]
	
	return not (effect.stacks < min_stacks or effect.stage < min_stage)

func queue_removal(effect: StringName) -> void:
	removal_queue.append(effect)

func remove_effects() -> void:
	for effect in removal_queue:
		if effect in status_effects:
			status_effects.erase(effect)
