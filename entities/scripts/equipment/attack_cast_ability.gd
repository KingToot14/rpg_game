class_name AttackCastAbility
extends EquipmentAbility

# --- Variables --- #
@export var action_name := &'attack'
@export var attack_name: String
@export var odds := 0.25

# --- Functions --- #
func setup(new_entity: Entity, new_level: int) -> void:
	super(new_entity, new_level)
	
	# setup signals
	entity.action_performed.connect(_on_action_performed)

func _on_action_performed(params: Dictionary) -> void:
	if randf() > odds:
		return
	
	Globals.turn_fsm.queue_attack({
		&'attack_name': attack_name,
		&'type': &'addition',
		&'params': {
			&'is_counter': true
		}
	})
