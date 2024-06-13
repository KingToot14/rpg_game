class_name AnimationExposer
extends Node2D

# --- Variables --- #
@export var animator: AttackAnimator
@export var sprite: Sprite2D

# --- Functions --- #
func play_animation(anim_name: StringName) -> void:
	animator.play(anim_name)

func set_target(target: Entity) -> void:
	animator.target = target

func set_sprite_frame(frame: int) -> void:
	sprite.frame = frame
