class_name DialogueObject
extends Interactable

# --- Variables --- #
@export var npc_name: String
@export var look_at_player := false
# @@show_if(look_at_player)
@export var sprite: Sprite2D

@export_file("*.tres") var npc_info_path: String
@export_file("*.dialogue") var dialogue_path: String
@export var dialogue_title: String
var curr_title: String
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
	if is_instance_valid(Globals.curr_dialogue):
		return
	
	# look at player
	if look_at_player:
		update_texture()
	
	PortraitManager.set_portrait(npc_resource, "happy")
	get_title()
	
	if balloon_path.is_empty():
		DialogueManager.show_dialogue_balloon(dialogue, curr_title)
	else:
		DialogueManager.show_dialogue_balloon_scene(balloon_path, dialogue, curr_title)

func update_texture() -> void:
	var direction = Vector2.ZERO
	
	if direction == Vector2.ZERO:
		return
	
	sprite.flip_h = direction.x > 0.0
	
	if abs(direction.x) < 0.1:
		sprite.frame = 0 if direction.y >= 0.0 else 2
	else:
		sprite.frame = 1 if direction.y >= 0.0 else 3

func get_title() -> void:
	if not dialogue_title.is_empty():
		curr_title = dialogue_title
		return
	
	curr_title = DataManager.get_dialogue_state(npc_name)
