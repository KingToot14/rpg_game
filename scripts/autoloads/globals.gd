extends Node2D

# --- General --- #
var object_pool: ObjectPool
var ui_manager: CanvasLayer

# --- Overworld --- #
const OVERWORLD_SCENE: String = "res://scenes/overworld_root.tscn"

var overworld_manager: OverworldManager
var overworld_area: String = "res://scenes/testing/starting_area.tscn"

# --- Encounters --- #
var encounter_manager: EncounterManager
var encounter_resource: String

var curr_entity: Entity
var curr_targets: Array[Entity] = [null, null, null, null, null]

var curr_item: Resource

var timing_mods: Array[float] = []

var action_fsm: ActionFSM
var attack_manager: AttackManager
