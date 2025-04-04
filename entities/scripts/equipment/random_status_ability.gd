class_name RandomStatusAbility
extends EquipmentAbility

# --- Variables --- #
@export var status_key: StringName
@export var stacks := 1
@export var stage := 1
@export var odds := 0.25

@export var side: Attack.TargetSide
@export var target_self := true

# --- Functions --- #
func setup_signals() -> void:
	entity.side_changed.connect(_on_side_changed)

func remove_signals() -> void:
	entity.side_changed.disconnect(_on_side_changed)

func _on_side_changed(params: Dictionary) -> void:
	# only cast when the correct side has changed
	if params[&'side'] == "player" and not entity.is_player():
		return
	if params[&'side'] == "enemy" and entity.is_player():
		return
	
	for e: Entity in [entity] if target_self else TargetingHelper.get_entities(params[&'side']):
		# try to add status
		if randf() > odds:
			continue
		
		e.status_effects.add_effect(status_key, stacks, stage)
