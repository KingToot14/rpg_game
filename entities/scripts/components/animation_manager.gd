class_name AnimationManager
extends Node

# --- Signals --- #
signal entered_battle()
signal action_started()

# --- Variables --- #
@export var animator: AnimationPlayer

@export var overrideable_anims := ['idle', 'take_damage']
@export var main_sprite: Sprite2D

# --- References --- #
var parent: Entity

# --- Functions --- #
func _ready() -> void:
	await get_tree().process_frame
	animator.animation_finished.connect(_on_animation_finished)

func setup(entity: Entity) -> void:
	parent = entity
	
	if not main_sprite:
		main_sprite = parent.get_node_or_null(^'sprite')

func play_enter_anim() -> void:
	# play animation after setup
	animator.play(&'enter_battle')
	animator.animation_finished.connect(entered_battle.emit, CONNECT_ONE_SHOT)

func _on_animation_finished(_anim_name: StringName) -> void:
	animator.play(&'idle')

func play_damage_anim(_dmg_chunk: Dictionary) -> void:
	# if currently acting, play a simple flash
	if animator.current_animation != "" and animator.current_animation not in overrideable_anims:
		simple_flash()
		return
	
	if parent.hp.alive:
		animator.stop()
		animator.play(&'take_damage')
	else:
		parent.remove_from_battle()
		animator.play(&'death')

func play_action_anim(anim_name: StringName) -> void:
	animator.play(anim_name)
	
	action_started.emit()
	
	await animator.animation_finished

func play_idle_anim() -> void:
	animator.play(&"idle")

#region Timing
func get_timed_inputs(attack_name: StringName) -> Array[Array]:
	var attack_anim = animator.get_animation(attack_name)
	
	if not attack_anim:
		return []
	
	var track_id = attack_anim.find_track(^'managers/animator', Animation.TYPE_METHOD)
	
	if track_id < 0:
		return []
	
	var key_count = attack_anim.track_get_key_count(track_id)
	
	var locations: Array[Array] = []
	for i in range(key_count):
		var track_vals = attack_anim.track_get_key_value(track_id, i)
		if track_vals['method'] == &'timed_input':
			var repetitions = 1 if len(track_vals['args']) == 0 else track_vals['args'][0]
			
			locations.append([roundi(attack_anim.track_get_key_time(track_id, i) * 60), repetitions])
	
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

#endregion

#region Flash
func simple_flash() -> void:
	var tween = create_tween()
	
	tween.tween_method(func (x): main_sprite.material.set_shader_parameter('intensity', x), 0, 1, 0.05)
	tween.tween_method(func (x): main_sprite.material.set_shader_parameter('intensity', x), 1, 0, 0.10)

#endregion
