class_name ActionResource
extends Resource

# --- Variables --- #
@export var name: String
@export var animation_name: StringName
@export var icon: Texture2D

@export_multiline var description: String

@export var cooldown: int
var remaining_cooldown: int

# --- Functions --- #
func can_target(_target: Entity) -> bool:
	return false
