class_name OnTurnAbility
extends EquipmentAbility

# --- Variables --- #
@export var min_turn := 1
@export var max_turn := 1

@export var status_key: StringName
@export var stacks := 1
@export var stage := 1

var turn := 1

# --- Functions --- #
func setup_signals() -> void:
	entity.side_changed.connect(_on_side_changed)

func _on_side_changed(params: Dictionary) -> void:
	# only cast when the correct side has changed
	if params[&'side'] == "player" and not entity.is_player():
		return
	if params[&'side'] == "enemy" and entity.is_player():
		return
	
	if turn < min_turn or turn > max_turn:
		return
	
	entity.status_effects.add_effect(status_key, stacks, stage)
	
	turn += 1
