class_name StatusEffectManager
extends Node

# --- Signals --- #
signal effect_added()

# --- Variables --- #
var status_effects: Array[StatusEffect] = []
var removal_queue: Array[StringName] = []

# --- References --- #
var parent: Entity

# --- Functions --- #
func setup(entity: Entity) -> void:
	parent = entity

func _on_turn_started() -> void:
	for effect in status_effects:
		effect.turn_started()
	
	remove_effects()

func _on_turn_ended() -> void:
	for effect in status_effects:
		effect.turn_ended()
	
	remove_effects()

func add_effect(key: StringName, stacks := 1, stage := 1) -> void:
	var effect = get_effect(key)
	
	if effect:
		effect.add_stacks(stacks, stage)
	else:
		status_effects.append(Globals.registered_effects[key].new(parent, stacks, stage))
	
	effect_added.emit()

func get_effect(key: StringName) -> StatusEffect:
	for effect in status_effects:
		if effect.key == key:
			return effect
	
	return null

func has_effect(key: StringName, min_stacks := 0, min_stage := 0) -> bool:
	var effect = get_effect(key)
	
	if not effect:
		return false
	
	return not (effect.stacks < min_stacks or effect.stage < min_stage)

func queue_removal(effect: StringName) -> void:
	removal_queue.append(effect)

func remove_effects() -> void:
	for effect in status_effects:
		if effect.key in removal_queue:
			status_effects.erase(effect)
	
	removal_queue.clear()
