class_name AttackObject
extends Node2D

# --- Variables --- #
@export var attack: Attack
@export var animator: AttackAnimator

var entity: Entity
var target

var side: StringName

# --- Functions --- #
func setup(params: Dictionary) -> void:
	entity = params.get(&'entity', null)
	target = params.get(&'target', null)
	
	if animator:
		animator.entity = entity
		animator.target = target
	
	side = params.get(&'side', &'entity')
	
	attack = entity.brain.action as Attack

func perform_attack() -> void:
	#var animator := get_node_or_null(^'animator') as AttackAnimator
	
	if not animator:
		return
	
	animator.play(&'do_attack')
