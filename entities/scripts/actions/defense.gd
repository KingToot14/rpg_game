class_name Defense
extends ActionResource

# --- Variables --- #
@export var defense_value := 0.5

# --- Functions --- #
func do_defense() -> void:
	Globals.curr_entity.status_effects.add_effect(&'defend', 1)

func highlight_targets() -> void:
	Globals.curr_entity.targeting.set_targetable(true)

func start_cooldown(val: int = -1) -> void:
	if val < 0:
		if cooldown > 0:
			val = cooldown + 1
		else:
			val = 0
	
	remaining_cooldown = val

func decrement_cooldown() -> void:
	remaining_cooldown = max(remaining_cooldown - 1, 0)
