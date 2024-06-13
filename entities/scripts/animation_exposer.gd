class_name AnimationExposer
extends Node2D

# --- Variables --- #
@export var animator: AnimationPlayer

# --- Functions --- #
func play_animation(anim_name: String) -> void:
	animator.play(anim_name)
