class_name CounterAbility
extends EquipmentAbility

# --- Variables --- #
@export var attack_name: StringName
@export var odds := 0.25

var countered := false

# --- Functions --- #
func setup(new_entity: Entity, new_level: int) -> void:
	super(new_entity, new_level)
	
	# setup signals
	entity.took_damage.connect(_on_take_damage)
	entity.deal_damage.connect(_on_deal_damage)

func remove_signals() -> void:
	entity.took_damage.disconnect(_on_take_damage)
	entity.deal_damage.disconnect(_on_deal_damage)

func _on_deal_damage(_params: Dictionary) -> void:
	countered = false

func _on_take_damage(params: Dictionary) -> void:
	# don't counter counters, and only once per attack
	if params.get(&'is_counter', false) or countered:
		return
	
	if randf() > odds:
		return
	
	countered = true
	
	Globals.turn_fsm.queue_attack({
		&'attack_name': attack_name,
		&'entity': entity,
		&'target': params.get(&'entity', null),
		&'type': &'queued',
		&'is_counter': true
	})
