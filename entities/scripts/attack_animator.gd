class_name AttackAnimator
extends AnimationPlayer

# --- Variables --- #
@onready var parent := $".." as Entity

# --- Functions --- #
func do_damage() -> void:
	Globals.attack_manager.do_damage()

func jump_to(tag: String) -> void:
	pass

func move_towards(key: String, time: float) -> void:
	move_from(key, time, Vector2.ZERO)

func move_from(key: String, time: float, offset: Vector2) -> void:
	var target = null
	var global = true
	
	match key:
		'target':
			target = Globals.curr_target.global_position
		'home':
			target = Vector2.ZERO
			global = false
		'front':
			target = Globals.curr_target.get_front_pos()
	
	if offset != Vector2.ZERO:
		if global:
			parent.global_position = target + offset
		else:
			parent.position = target + offset
	
	var tween = create_tween()
	if global:
		tween.tween_property(parent, 'global_position', target, time)
	else:
		tween.tween_property(parent, 'position', target, time)

func set_visible(val: bool) -> void:
	parent.visible = val
