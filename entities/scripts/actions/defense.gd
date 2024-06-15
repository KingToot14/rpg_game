class_name Defense
extends Resource

# --- Variables --- #
@export var name: String
@export var animation_name: StringName
@export var icon: Texture2D

@export var cooldown: int = 0
var remaining_cooldown := 0

@export_multiline var description: String

@export var defense_value := 0.5

# --- Functions --- #
func do_defense() -> void:
	Globals.curr_entity.add_effect(&'defend', 1)

func highlight_targets() -> void:
	Globals.curr_entity.set_targetable(true)

func start_cooldown(val: int = -1) -> void:
	if val < 0:
		if cooldown > 0:
			val = cooldown + 1
		else:
			val = 0
	
	remaining_cooldown = val

func decrement_cooldown() -> void:
	remaining_cooldown = max(remaining_cooldown - 1, 0)
