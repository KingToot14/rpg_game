class_name OnActionAbility
extends EquipmentAbility

# --- Variables --- #
@export var action_name: StringName

@export var status_key: StringName
@export var stacks := 1
@export var stage := 1

@export var odds := 0.25

@export var target_self := true

# --- Functions --- #
func setup_signals() -> void:
	entity.performed_action.connect(_on_performed_action)

func remove_signals() -> void:
	entity.performed_action.disconnect(_on_performed_action)

func _on_performed_action(params: Dictionary) -> void:
	if params[&'action'] != action_name:
		return
	
	# try to add status
	if randf() > odds:
		return
	
	var target: Entity = null
	
	if target_self:
		target = entity
	else:
		target = params.get(&'target', null)
	
	if target:
		target.status_effects.add_effect(status_key, stacks, stage)
