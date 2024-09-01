class_name DialogueObject
extends Interactable

# --- Variables --- #
@export var dialogue_title: String
var curr_title: String
@export_file("*.tscn") var balloon_path: String
@export var dialogue: DialogueResource
@export var npc_resource: NpcInformation

@export_group("NPC Info")
@export var npc_name: String
@export var look_at_player := false

@export_group("Sound Effects")
@export var interact_sfx: AudioStream

# --- References --- #
@onready var sprite := get_node_or_null('%sprite') as Sprite2D

# --- Functions --- #
func _ready():
	super()
	
	interacted_with.connect(show_dialogue)

func show_dialogue():
	if is_instance_valid(Globals.curr_dialogue):
		return
	
	# play sfx
	if interact_sfx and %'audio_player':
		%'audio_player'.play_sfx(interact_sfx)
	
	# look at player
	if look_at_player:
		update_texture()
	
	# set npc info
	DialogueManager.curr_npc_info = npc_resource
	
	get_title()
	
	if balloon_path.is_empty():
		DialogueManager.show_dialogue_balloon(dialogue, curr_title, npc_resource)
	else:
		DialogueManager.show_dialogue_balloon_scene(balloon_path, dialogue, curr_title, npc_resource)

func update_texture() -> void:
	var direction = position.direction_to(Globals.overworld_manager.player.position)
	
	if direction == Vector2.ZERO:
		return
	
	sprite.flip_h = direction.x > 0.0
	
	if abs(direction.x) < 0.25:
		sprite.frame = 0 if direction.y >= 0.0 else 2
	else:
		sprite.frame = 1 if direction.y >= 0.0 else 3

func get_title() -> void:
	if not dialogue_title.is_empty():
		curr_title = dialogue_title
		return
	
	curr_title = DataManager.get_dialogue_state(npc_name)
