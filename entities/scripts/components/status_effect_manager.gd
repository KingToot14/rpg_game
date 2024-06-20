class_name StatusEffectManager
extends Node

# --- Variables --- #
var status_effects = {}
var removal_queue: Array[StringName] = []

# --- References --- #
var parent: Entity

# --- Functions --- #
func setup(entity: Entity) -> void:
	parent = entity

func _on_turn_ended() -> void:
	for effect in status_effects:
		effect.turn_ended()
	
	remove_effects()

func get_effects():
	return status_effects.values()

func add_effect(key: StringName, stacks: int = 1, stage: int = 1) -> void:
	if key in status_effects:
		status_effects[key].add_stacks(stacks, stage)
	else:
		status_effects[key] = Globals.registered_effects[key].new(parent, stacks, stage)

func queue_removal(effect: StringName) -> void:
	removal_queue.append(effect)

func remove_effects() -> void:
	for effect in removal_queue:
		if effect in status_effects:
			status_effects.erase(effect)
