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
	var target = null
	
	match key:
		'target':
			target = Globals.curr_targets[0].global_position
		'home':
			target = Globals.curr_entity.home_position
		'front':
			target = Globals.curr_targets[0].get_front_pos()
	
	var tween = create_tween()
	tween.tween_property(parent, 'global_position', target, time)
