class_name DefendingStatus
extends StatusEffect

# --- Variables --- #
var dmg_mod := 0.5

# --- Functions --- #
func setup_signals() -> void:
	entity.turn_ended.connect(_root_turn_ended)
	
	entity.turn_started.connect(_on_turn_started)
	entity.took_damage.connect(_on_take_damage)

func set_status_info() -> void:
	additive = false
	
	icon_pos = Vector2(3, 1)
	
	key = &'defend'
	name = "Defending"
	description = "Receives less damage for one turn"

func _on_turn_started(params: Dictionary) -> void:
	if not params.get(&'visited_before', false):
		remove_status()

func _on_take_damage(dmg_chunk: Dictionary) -> void:
	if dmg_chunk.get(&'source', &'unset') != &'entity':
		return
	
	dmg_chunk[&'damage'] = roundi(dmg_chunk[&'damage'] * dmg_mod)
