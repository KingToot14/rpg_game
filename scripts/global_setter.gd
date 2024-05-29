class_name GlobalSetter
extends Node2D

# --- Variables --- #
@export var global_variable: String

# --- Functions --- #
func _ready():
	match global_variable:
		"grass_viewport":
			Globals.grass_viewport = self
