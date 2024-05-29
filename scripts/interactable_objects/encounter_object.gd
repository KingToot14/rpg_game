class_name EncounterObject
extends Interactable

# --- Variables --- #
@export_file("*tres") var encounter_path: String
@export_file("*tscn") var battle_path: String

# --- Functions --- #
func _ready():
	super()
	interacted_with.connect(start_encounter)

func start_encounter():
	print("Started encounter with ", encounter_path, " on ", battle_path)
	
	Globals.encounter_resource = encounter_path
	Globals.overworld_manager.load_battle(battle_path)
	
	interactable = false
	queue_free()
