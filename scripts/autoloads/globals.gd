extends Node2D

# --- General --- #
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
var overworld_area: String = "res://scenes/forest/starting_area/starting_area.tscn"

# --- Encounters --- #
var from_battle: bool = false

var encounter_manager: EncounterManager
var encounter_resource: String

var timing_mods: Array[StringName] = []

var turn_fsm: TurnFSM

# --- Functions --- #
func _ready() -> void:
	# load default preset
	set_preset(load("res://resources/theme_presets/blue_preset.tres"))
