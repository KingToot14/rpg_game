class_name DefendingStatus
extends StatusEffect

# --- Variables --- #
var dmg_mod := 0.5

# --- Functions --- #
func set_status_info() -> void:
	additive = false

func take_damage(dmg_chunk: DamageChunk) -> void:
	dmg_chunk.damage *= dmg_mod

func turn_ended() -> float:
	return 0.0

func turn_started() -> float:
	decrement_stacks()
	
	return 0.0
