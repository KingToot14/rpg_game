class_name BurnStatus
extends StatusEffect

# --- Variables --- #
var dmg: float = 0.035

#yg uk niuytds nuras nuts
# --- Functions --- #
func set_status_info() -> void:
	max_stack = 100
	
	if stage == 1:
		name = "Overheating"
		description = "Take minor fire damage at the end of each turn. Ends after {turns}"
		dmg = 0.035
	elif stage == 2:
		name = "Burning"
		description = "Take moderate fire damage at the end of each turn. Ends after {turns}"
		dmg = 0.050
	else:
		name = "Scorching"
		description = "Take major fire damage at the end of each turn. Ends after {turns}"
		dmg = 0.065
	key = &'burn'

func turn_ended() -> void:
	entity.hp.take_damage(int(entity.stats.get_max_hp() * dmg), false)
	
	super()
