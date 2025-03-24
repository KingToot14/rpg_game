class_name StatusImmune
extends EquipmentAbility

# --- Variables --- #
@export var status_key: StringName
@export var immunity_chance := 0.50

# --- Functions --- #
func setup_signals() -> void:
	entity.received_status.connect(_on_receive_status)

func remove_signals() -> void:
	entity.received_status.disconnect(_on_receive_status)

func _on_receive_status(params: Dictionary) -> void:
	if params[&'key'] == status_key and randf() <= immunity_chance:
		params[&'ignore'] = true
