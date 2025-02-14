class_name AttackAnimator
extends AnimationPlayer

# --- Variables --- #
@export var parent: Node2D
var entity: Entity

var target = null

# --- Functions --- #
func _ready() -> void:
	if parent is Entity:
		entity = parent

func timed_input(_reps := 1) -> void:
	return

#region Actions
func do_damage(modifier: float = 1.0) -> void:
	if target is Array:
		for targ in target:
			if is_instance_valid(targ):
				entity.brain.do_damage(targ, modifier)
	elif is_instance_valid(target):
		entity.brain.do_damage(target, modifier)
	
	if len(Globals.timing_mods) > 0:
		Globals.timing_mods.pop_front()

func perform_action() -> void:
	entity.brain.action.perform_action(target)

#endregion

func add_effect(key: StringName, stacks := 1, stage := 1) -> void:
	var params = {
		&'key': key,
		&'stacks': stacks,
		&'stage': stage
	}
	
	parent.gave_status.emit(params)
	
	target.status_effects.add_effect(params[&'key'], params[&'stacks'], params[&'stage'])

#region Targeting
func set_target() -> void:
	var action = entity.brain.action
	
	match action.targeting:
		Attack.TargetingMode.SINGLE, Attack.TargetingMode.AOE:
			target = entity.brain.selected_target
		Attack.TargetingMode.ALL:
			target = TargetingHelper.get_entities(action.get_side_string())
		Attack.TargetingMode.RANDOM:
			target = TargetingHelper.get_random_entity(action.get_side_string())

func target_neighbors(depth := 1, include_self := false) -> void:
	if not target:
		return
	
	var index = target.spawn_index
	var side = entity.brain.action.get_side_string()
	target = []
	
	for dist in range(1, depth + 1):
		target.append(TargetingHelper.get_entity_by_index(side, index - dist, true))
		target.append(TargetingHelper.get_entity_by_index(side, index + dist, true))
	
	if include_self:
		target.append(TargetingHelper.get_entity_by_index(side, index, true))

func move_towards(key: String, time: float) -> void:
	move_from(key, time, Vector2.ZERO)

func move_from(key: String, time: float, offset: Vector2) -> void:
	var pos := Vector2.ZERO
	var global = true
	
	match key:
		'target':
			if not target:
				return
			
			pos = target.global_position
		'home':
			pos = Vector2.ZERO
			global = false
		'front':
			if not target:
				return
			
			pos = target.get_front_pos()
		'offset':
			pos = offset
			offset = Vector2.ZERO
			global = false
	
	if offset != Vector2.ZERO:
		if global:
			parent.global_position = pos + offset
		else:
			parent.position = pos + offset
	
	var tween = create_tween()
	if global:
		tween.tween_property(parent, 'global_position', pos, time)
	else:
		tween.tween_property(parent, 'position', pos, time)

#endregion

func set_visible(val: bool) -> void:
	parent.visible = val

func screen_shake(intensity: float = 4, time = 0.25) -> void:
	get_viewport().get_camera_2d().do_screen_shake(intensity, time)

#region Busy System
func add_busy() -> void:
	Globals.turn_fsm.add_busy()

func remove_busy() -> void:
	Globals.turn_fsm.remove_busy()

func end_turn() -> void:
	entity.turn.end_turn()
	remove_busy()

#endregion

#region Queue System
func check_addition_attacks() -> void:
	Globals.turn_fsm.check_addition_attacks()

#endregion
