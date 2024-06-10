extends Node2D

# --- Signals --- #
signal item_set()

# --- General --- #
var object_pool: ObjectPool
var ui_manager: CanvasLayer

var curr_dialogue

# --- Overworld --- #
const OVERWORLD_SCENE: String = "res://scenes/overworld_root.tscn"

var overworld_manager: OverworldManager
var overworld_area: String = "res://scenes/testing/starting_area.tscn"

# --- Encounters --- #
var encounter_manager: EncounterManager
var encounter_resource: String

var curr_entity: Entity
var curr_target: Entity

var curr_item: Resource
func set_item(item: Resource) -> void:
	curr_item = item
	item_set.emit()

var timing_mods: Array[float] = []

var action_fsm: ActionFSM
var attack_manager: AttackManager
