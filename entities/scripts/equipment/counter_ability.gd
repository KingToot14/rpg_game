class_name CounterAbility
extends EquipmentAbility

# --- Variables --- #
@export var attack_name: String
@export var odds := 0.25

# --- Functions --- #
func setup(new_entity: Entity, new_level: int) -> void:
	super(new_entity, new_level)
	
	# setup signals
	entity.took_damage.connect(_on_take_damage)

func _on_take_damage(params: Dictionary) -> void:
	# don't counter counters
	if params.get(&'is_counter', false):
		return
	
	if randf() > odds:
		return
	
	Globals.turn_fsm.queue_attack({
		&'attack_name': attack_name,
		&'type': &'counter',
		&'params': {
			&'is_counter': true
		}
	})
