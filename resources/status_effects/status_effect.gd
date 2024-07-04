class_name StatusEffect
extends Resource

# --- Variables --- #
var entity: Entity = null

var name: String = "Status"
var description: String = "Description"
var key: StringName = &'key'
var icon: Texture2D = null

var stage: int = 1
var stacks: int = 1
var max_stack: int = 1
var additive: bool = true

var decrement_value: int = 1

# --- Functions --- #
func _init(init_entity: Entity = null, init_stacks: int = 1, init_stage: int = 1) -> void:
	entity = init_entity
	
	stacks = init_stacks
	stage = init_stage
	
	set_status_info()

func set_status_info() -> void:
	return

func set_stacks(new_stacks: int) -> void:
	stacks = clamp(new_stacks, 0, max_stack)

func decrement_stacks() -> void:
	set_stacks(stacks - decrement_value)
	
	if stacks <= 0:
		remove_status()

func add_stacks(new_stacks: int = 1, new_stage: int = 1) -> void:
	if new_stage < stage:
		return
	
	if additive:
		set_stacks(stacks + new_stacks)
	else:
		if new_stacks > stacks:
			set_stacks(new_stacks)
	
	set_status_info()

func remove_status() -> void:
	entity.status_effects.queue_removal(key)

# - Effects - #
func turn_started() -> void:
	return

func turn_ended() -> void:
	decrement_stacks()

func take_damage(dmg: float) -> float:
	return dmg

func get_max_hp(hp: float) -> float:
	return hp

func get_p_attack(attack: float) -> float:
	return attack

func get_m_attack(attack: float) -> float:
	return attack

func get_p_defense(defense: float) -> float:
	return defense

func get_m_defense(defense: float) -> float:
	return defense

func get_accuracy(accuracy: float) -> float:
	return accuracy

func get_evasion(evasion: float) -> float:
	return evasion

func get_resistance(_resistance: Attack.Element, mod: float) -> float:
	return mod
