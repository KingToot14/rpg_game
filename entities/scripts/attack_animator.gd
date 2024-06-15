class_name AttackAnimator
extends AnimationPlayer

# --- Variables --- #
@onready var parent := $".." as Node2D
var target = null

# --- Functions --- #
func do_damage(modifier: float = 1.0) -> void:
	if target is Array:
		for targ in target:
			if is_instance_valid(targ):
				Globals.attack_manager.do_damage(targ, modifier)
	elif is_instance_valid(target):
		Globals.attack_manager.do_damage(target, modifier)
	
	if len(Globals.timing_mods) > 0:
		Globals.timing_mods.pop_front()

func do_defense() -> void:
	Globals.curr_item.do_defense()

func set_target() -> void:
	var attack = Globals.curr_item as Attack
	
	match attack.targeting:
		Attack.TargetingMode.SINGLE, Attack.TargetingMode.AOE:
			target = Globals.curr_target
		Attack.TargetingMode.ALL:
			if attack.side == Attack.TargetSide.ENEMY:
				target = TargetingHelper.get_entities(&'enemy')
			else:
				target = TargetingHelper.get_entities(&'player')
		Attack.TargetingMode.RANDOM:
			if attack.side == Attack.TargetSide.ENEMY:
				target = TargetingHelper.get_random_entity(&'enemy')
			else:
				target = TargetingHelper.get_random_entity(&'player')

func move_towards(key: String, time: float) -> void:
	move_from(key, time, Vector2.ZERO)

func move_from(key: String, time: float, offset: Vector2) -> void:
	var pos := Vector2.ZERO
	var global = true
	
	match key:
		'target':
			pos = target.global_position
		'home':
			pos = Vector2.ZERO
			global = false
		'front':
			pos = Globals.curr_target.get_front_pos()
	
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

func set_visible(val: bool) -> void:
	parent.visible = val
