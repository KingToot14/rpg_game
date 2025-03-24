class_name AttackCastAbility
extends EquipmentAbility

# --- Variables --- #
@export_file("*tscn") var attack_object: String
@export var attack_name: String
@export var odds := 0.25

# --- Functions --- #
func setup_signals() -> void:
	# setup signals
	entity.performed_action.connect(_on_action_performed)

func remove_signals() -> void:
	entity.performed_action.disconnect(_on_action_performed)

func _on_action_performed(params: Dictionary) -> void:
	if randf() > odds:
		return
	
	Globals.turn_fsm.queue_attack({
		&'attack_object': attack_object,
		&'entity': entity,
		&'target': params.get(&'target', null),
		&'type': &'addition',
		&'is_counter': true
	})
