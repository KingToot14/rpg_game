class_name WaveItem
extends Resource

# --- Variables --- #
@export_file("*.tscn") var entity_path: String
@export var level := 1
@export var use_custom_position := false
# @@show_if(use_custom_position)
@export var position: Vector2

# --- Functions --- #

