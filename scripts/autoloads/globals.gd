extends Node2D

# --- Enums --- #
enum Stat {
	HEALTH,
	P_ATTACK,
	M_ATTACK,
	P_DEFENSE,
	M_DEFENSE,
	EVASION,
	ACCURACY
}

enum EquipAction {
	DEFEND,
	SKIP
}

enum EquipVerb {
	CAST,
	SUMMON,
	UNLEASH
}

enum EquipAbility {
	BOOST,
	RANDOM_CAST,
	GIVE_STATUS,
	ACTION_STATUS,
	COUNTER,
	ATTACK_CAST,
	RESIST_ELEMEMENT,
	RESIST_STATUS
}

enum StatusType {
	EMPTY = 0,
	HARASS = 1,
	HINDER = 2,
	LIFE = 4,
	DEATH = 8,
	BODY = 16,
	ENVIRONMENT = 32
}

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

# --- Resources --- #
var status_effect_icons := "res://ui/icons/effects.png"

var status_effects: Dictionary[StringName, String] = {
	&'burn': "res://resources/status_effects/burn_status.gd",
	&'haste': "res://resources/status_effects/haste_status.gd",
	&'bleed': "res://resources/status_effects/bleed_status.gd",
	&'defend': "res://resources/status_effects/defending_status.gd",
	&'charge': "res://resources/status_effects/blank_status.gd",
	&'wet': "res://resources/status_effects/wet_status.gd",
	&'poison': "res://resources/status_effects/poison_status.gd",
}

# --- Functions --- #
func _ready() -> void:
	# load default preset
	set_preset(load("res://resources/theme_presets/blue_preset.tres"))

#region Status Effects
func load_status_effect(key: StringName) -> GDScript:
	return load(status_effects.get(key))

func load_status_effect_icon(x: int, y: int) -> Texture2D:
	var texture := AtlasTexture.new()
	texture.atlas = load(status_effect_icons)
	texture.region = Rect2(x, y, 10, 10)
	
	return texture

#endregion
