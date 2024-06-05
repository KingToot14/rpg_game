class_name DialogueObject
extends Interactable

# --- Variables --- #
@export_file("*.tres") var npc_info_path: String
@export_file("*.dialogue") var dialogue_path: String
@export_file var bubble_path: String

# --- References --- #
var dialogue: DialogueResource
var npc_resource: NpcInformation

# --- Functions --- #
func _ready():
	super()
	if npc_info_path:
		AsyncLoader.new(npc_info_path, func f(r): npc_resource = r)
	
	AsyncLoader.new(dialogue_path, func f(d: DialogueResource): dialogue = d)
	
	interacted_with.connect(show_dialogue)

func show_dialogue():
	PortraitManager.set_portrait(npc_resource, "happy")
	DialogueManager.show_dialogue_balloon(dialogue)
