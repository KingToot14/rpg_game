class_name BleedStatus
extends StatusEffect

# --- Variables --- #
var dmg := 0.035
var heal_mod := 0.90

# --- Functions --- #
func set_status_info() -> void:
	max_stack = 100
	
	dmg = 0.020 + 0.015 * stage
	
	match stage:
		1:
			heal_mod = 0.90
		2:
			heal_mod = 0.75
		3:
			heal_mod = 0.50

func take_damage(dmg_chunk: DamageChunk) -> void:
	# ignore taking damage
	if dmg_chunk.damage > 0:
		return
	
	# reduce healing
	dmg_chunk.damage *= heal_mod

func turn_ended() -> float:
	var dmg_chunk = DamageChunk.new(roundi(entity.stats.get_max_hp() * dmg), Attack.Element.NONE, 1.0)
	
	entity.hp.take_damage(dmg_chunk, false)
	
	super()
	
	return DELAY_DURATION
