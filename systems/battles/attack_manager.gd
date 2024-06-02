class_name AttackManager
extends Node2D

# --- Variables --- #


# --- Functions --- #
func _ready() -> void:
	Globals.attack_manager = self

func do_damage() -> void:
	var attack = Globals.curr_item as Attack
	var dmg = round(attack.calculate_damage(Globals.curr_entity, Globals.curr_targets[0]))
	
	Globals.curr_targets[0].take_damage(dmg)
