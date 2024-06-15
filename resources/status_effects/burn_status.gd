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
		dmg = 0.035
	elif stage == 2:
		name = "Burning"
		dmg = 0.050
	else:
		name = "Scorching"
		dmg = 0.065
	key = &'burn'

func turn_ended() -> void:
	entity.take_damage(entity.get_max_hp() * dmg, false)
	
	super()
