class_name TransformGlobalizer
extends Node

# --- Variables --- #
@export var node_to_push_to: Node2D
@export var root: Node2D

@export var pos_offset: Vector2
@export var update_pos := true

# --- Functions --- #
func _process(_delta: float) -> void:
	if update_pos:
		node_to_push_to.global_position = root.global_position + pos_offset
	
