class_name DefendingStatus
extends StatusEffect

# --- Variables --- #
var dmg_mod := 0.5

# --- Functions --- #
func setup_signals() -> void:
	entity.turn_started.connect(_on_turn_started)
	entity.took_damage.connect(_on_take_damage)

func set_status_info() -> void:
	additive = false

func _on_turn_started(params: Dictionary) -> void:
	if not params.get(&'visited_before', false):
		decrement_stacks()

func _on_take_damage(dmg_chunk: Dictionary) -> void:
	dmg_chunk[&'damage'] *= dmg_mod
