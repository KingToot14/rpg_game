class_name Encounter
extends Interactable

# --- Variables --- #
@export var encounter_path: String

# --- Functions --- #
func _ready():
	super()
	interacted_with.connect(start_encounter)

func start_encounter():
	print("Started encounter with path: ", encounter_path)
	interactable = false
	queue_free()
