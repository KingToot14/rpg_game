class_name AttackObject
extends Node2D

# --- Variables --- #
@export var attack: Attack

var entity: Entity
var target

var side: StringName

# --- Functions --- #
func setup(params: Dictionary) -> void:
	entity = params.get(&'entity', null)
	target = params.get(&'target', null)
	
	side = params.get(&'side', &'entity')
	
	attack = entity.brain.action as Attack

func perform_attack() -> void:
	pass
