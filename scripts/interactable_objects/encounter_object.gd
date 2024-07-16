class_name EncounterObject
extends Interactable

# --- Variables --- #
@export_file("*tres") var encounter_path: String
@export_file("*tscn") var battle_path: String

@export var encounter_texture: Texture2D
# @@buttons("Update Sprite", update_sprite())
@export var total_frames := 1
@export var anim_time := 0.50

# --- References --- #
@export var sprite: Sprite2D

# --- Functions --- #
func _ready() -> void:
	AsyncLoader.new(encounter_path, check_encounter)
	
	super()
	interacted_with.connect(start_encounter)
	
	update_sprite()
	
	# start animation
	var tween = create_tween().set_loops()
	
	tween.tween_property(sprite, 'frame', total_frames - 1, total_frames * anim_time).from(0)

func check_encounter(encounter: Encounter) -> void:
	var key = encounter.encounter_key
	if DataManager.is_defeated(key) or DataManager.local_area.is_defeated(key):
		queue_free()

func start_encounter() -> void:
	Globals.encounter_resource = encounter_path
	Globals.overworld_manager.load_battle(battle_path)
	
	interactable = false

func update_sprite() -> void:
	sprite.texture = encounter_texture
	sprite.hframes = total_frames
