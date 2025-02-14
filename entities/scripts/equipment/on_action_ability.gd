class_name OnActionAbility
extends EquipmentAbility

# --- Variables --- #
@export var action_name: String

@export var status_key: StringName
@export var stacks := 1
@export var stage := 1

@export var odds := 0.25

@export var target_self := true

# --- Functions --- #
func setup(new_entity: Entity, new_level: int) -> void:
	super(new_entity, new_level)
	
	entity.performed_action.connect(_on_performed_action)

func _on_performed_action(params: Dictionary) -> void:
	if params[&'action'] != action_name:
		return
	
	# try to add status
	if randf() > odds:
		return
	
	entity.status_effects.add_effect(status_key, stacks, stage)
