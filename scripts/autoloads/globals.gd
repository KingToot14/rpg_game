extends Node2D

# --- Signals --- #
signal item_set()

# --- Constants --- #
var registered_effects = {}

# --- General --- #
var object_pool: ObjectPool
var ui_manager: CanvasLayer

var curr_dialogue

var theme_preset: ThemePreset
func set_preset(preset: ThemePreset) -> void:
	theme_preset = preset
	var nodes = get_tree().get_nodes_in_group(&'theme_setter')
	
	for node in nodes:
		if 'update_theme' in node:
			node.update_theme()

# --- Overworld --- #
const OVERWORLD_SCENE: String = "res://scenes/overworld_root.tscn"

var overworld_manager: OverworldManager
var overworld_area: String = "res://scenes/testing/starting_area.tscn"

# --- Encounters --- #
var from_battle: bool = false

var encounter_manager: EncounterManager
var encounter_resource: String

var curr_entity: Entity
var curr_target: Entity

var curr_item: Resource
func set_item(item: Resource) -> void:
	curr_item = item
	item_set.emit()

var timing_mods: Array[StringName] = []

var action_fsm: ActionFSM
var turn_fsm: TurnFSM
var attack_manager: AttackManager

# --- Functions --- #
func _ready() -> void:
	# Fill registered effects
	find_status_effects("res://resources/status_effects/")
	
	# load default preset
	set_preset(load("res://resources/theme_presets/blue_preset.tres"))

func find_status_effects(path: String) -> void:
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				find_status_effects(dir.get_current_dir() + "/" + file_name)
			else:
				var effect_class = load(path + "/" + file_name)
				registered_effects[effect_class.new().key] = effect_class
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
