class_name AnimationManager
extends Node

# --- Variables --- #
@export var animator: AnimationPlayer

# --- References --- #
var parent: Entity

# --- Functions --- #
func _ready() -> void:
	animator.animation_finished.connect(_on_animation_finished)

func setup(entity: Entity) -> void:
	parent = entity
	
	animator.play(&'enter_battle')

func _on_animation_finished(_anim_name: StringName) -> void:
	animator.play(&'idle')

func play_damage_anim(_dmg: int) -> void:
	if parent.hp.alive:
		animator.stop()
		animator.play(&'take_damage')
	else:
		parent.remove_from_battle()
		animator.play(&'death')

func play_action_anim(anim_name: StringName) -> void:
	animator.play(anim_name)
	animator.animation_finished.connect(parent.action_ended, CONNECT_ONE_SHOT)

# - Timing - #
func get_timed_inputs(attack_name: StringName) -> Array[float]:
	var attack_anim = animator.get_animation(attack_name)
	if not attack_anim:
		return []
	
	var track_id = attack_anim.find_track(^'managers/animator', Animation.TYPE_METHOD)
	var key_count = attack_anim.track_get_key_count(track_id)
	
	var locations: Array[float] = []
	for i in range(key_count):
		if attack_anim.track_get_key_value(track_id, i)['method'] == &'timed_input':
			locations.append(attack_anim.track_get_key_time(track_id, i))
	
	return locations

func get_mash_inputs(attack_name: StringName) -> Array:
	var attack_anim = animator.get_animation(attack_name)
	if not attack_anim:
		return []
	
	var track_id = attack_anim.find_track(^'managers/animator', Animation.TYPE_METHOD)
	var key_count = attack_anim.track_get_key_count(track_id)
	
	for i in range(key_count):
		var value = attack_anim.track_get_key_value(track_id, i)
		if value['method'] == &'timed_input':
			return [attack_anim.track_get_key_time(track_id, i), value['args'][0]]
	
	return []
