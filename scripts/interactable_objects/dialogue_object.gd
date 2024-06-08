class_name DialogueObject
extends Interactable

# --- Variables --- #
@export var npc_name: String

@export_file("*.tres") var npc_info_path: String
@export_file("*.dialogue") var dialogue_path: String
@export var dialogue_title: String
@export_file("*.tscn") var balloon_path: String

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
	get_title()
	
	if balloon_path.is_empty():
		DialogueManager.show_dialogue_balloon(dialogue, dialogue_title)
	else:
		DialogueManager.show_dialogue_balloon_scene(balloon_path, dialogue, dialogue_title)

func get_title() -> void:
	if not dialogue_title.is_empty():
		return
	
	dialogue_title = DataManager.get_dialogue_state(npc_name)
