class_name AnimationExposer
extends Node2D

# --- Variables --- #
@export var animator: AttackAnimator
@export var sprite: Sprite2D

var callback: Callable

# --- Functions --- #
func play_animation(anim_name: StringName) -> void:
	animator.play(anim_name)

func set_target(target: Entity) -> void:
	animator.target = target

func set_sprite_frame(frame: int) -> void:
	sprite.frame = frame

func queue_method(method: Callable) -> void:
	callback = method
	animator.animation_finished.connect(do_callback, CONNECT_ONE_SHOT)

func do_callback(_s: StringName) -> void:
	callback.call()
