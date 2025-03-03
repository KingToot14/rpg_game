class_name ActionManager
extends Node

# --- Variables --- #
@export var default_attack: Attack
@export var attack_pool: Array[Attack]

# --- Functions --- #
func _ready() -> void:
	var entity := $'../..' as Entity
	
	entity.turn_ended.connect(_on_turn_ended)

func _on_turn_ended(_params := {}) -> void:
	for attack in attack_pool:
		attack.decrement_cooldown()

func get_attack(key: StringName) -> Attack:
	for attack: Attack in attack_pool:
		if attack.animation_name == key:
			return attack
	
	return

func get_random() -> Attack:
	var possible = attack_pool.duplicate()
	
	var attack := possible.pick_random() as Attack
	
	while attack.remaining_cooldown > 0 and len(possible) > 0:
		possible.erase(attack)
		attack = possible.pick_random()
	
	if len(possible) == 0:
		return null
	
	return attack
