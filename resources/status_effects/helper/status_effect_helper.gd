extends Node

# --- Variables --- #
@export var effects: Array[StatusEffectInfo] = []

# --- Functions --- #
func get_effect(key: StringName) -> StatusEffectInfo:
	for effect in effects:
		if effect.key == key:
			return effect
	
	return null
