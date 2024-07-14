@tool
class_name VariantCaller
extends Node

# --- Variables --- #
# @@buttons("Randomize", randomize_variants())
@export var dummy: int

# --- Functions --- #
func randomize_variants() -> void:
	for child in get_children():
		if 'randomize_variant' in child:
			child.randomize_variant()
