extends Node2D

# --- General --- #
var object_pool: ObjectPool

# --- Player --- #
var player_area_pos: Vector2 = Vector2(240, 135)

# --- Overworld --- #
const OVERWORLD_SCENE: String = "res://scenes/overworld_root.tscn"

var overworld_manager: OverworldManager
var overworld_area: String = "res://scenes/testing/starting_area.tscn"

# --- Encounters --- #
var encounter_resource: String

var curr_entity: Entity
var curr_targets: Array[Entity] = [null, null, null, null, null]

var curr_item: Resource

var action_fsm: ActionFSM
var attack_manager: AttackManager
