extends Node2D

# --- Player --- #
var player_area_pos: Vector2 = Vector2(240, 135)

# --- Overworld --- #
const OVERWORLD_SCENE: String = "res://scenes/overworld_root.tscn"

var overworld_manager: OverworldManager
var overworld_area: String = "res://scenes/testing/starting_area.tscn"

# --- Encounters --- #
var encounter_resource: String
