class_name BurnStatus
extends StatusEffect

# --- Variables --- #
var dmg: float = 0.035
var dmg_mod := 0.90

#yg uk niuytds nuras nuts
# --- Functions --- #
func set_status_info() -> void:
	max_stack = 100
	
	dmg = 0.020 + 0.015 * stage
	
	match stage:
		1:
			dmg_mod = 0.90
		2:
			dmg_mod = 0.50
		3:
			dmg_mod = 0.20

func turn_ended() -> float:
	var dmg_chunk = DamageChunk.new(roundi(entity.stats.get_max_hp() * dmg), Attack.Element.FIRE, 1.0)
	
	entity.hp.take_damage(dmg_chunk, false)
	
	super()
	
	return DELAY_DURATION

func take_damage(dmg_chunk: DamageChunk) -> void:
	# remove if water damage taken
	if dmg_chunk.element == Attack.Element.WATER:
		remove_status()
		return
	
	var mod := 0.0
	
	# nature and ice deal reduced damage
	if dmg_chunk.element & (Attack.Element.NATURE | Attack.Element.ICE):
		mod = 1.0
	
	dmg_chunk.damage *= (1.0 - dmg_chunk.element_percent) + (dmg_chunk.element_percent * (1.0 - mod))
