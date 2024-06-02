class_name AttackAnimator
extends AnimationPlayer

# --- Variables --- #


# --- Functions --- #
func do_damage() -> void:
	Globals.attack_manager.do_damage()
