class_name SignObject
extends Interactable

# --- Variables --- #
@export var dialogue_path: String
@export var bubble_path: String

# --- Functions --- #
func _ready():
	super()
	interacted_with.connect(read_sign)

func read_sign():
	print("Read sign (", bubble_path, ") with path: ", dialogue_path)
