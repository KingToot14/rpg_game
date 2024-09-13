class_name AnimationExposer
extends Node2D

# --- Variables --- #
@export var animator: AttackAnimator
@export var sprite: Sprite2D

@export var entity: Entity

var callback: Callable

# --- Functions --- #
func _ready() -> void:
	await get_tree().process_frame
	
	if animator and entity:
		animator.entity = entity

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
