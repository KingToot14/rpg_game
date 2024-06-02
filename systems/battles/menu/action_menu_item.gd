class_name ActionMenuItem
extends BaseButton

# --- Variables --- #
@export var item: Resource

# --- Functions --- #
func _ready() -> void:
	pressed.connect(set_item)

func set_item() -> void:
	Globals.curr_item = item
