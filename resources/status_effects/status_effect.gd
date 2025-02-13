class_name StatusEffect
extends Resource

# --- Variables --- #
var entity: Entity = null

var key: StringName = &'key'

var stage: int = 1
var stacks: int = 1
var max_stack: int = 1
var additive: bool = true

var decrement_value: int = 1

# --- Constants --- #
const DELAY_DURATION = 0.50

# --- Functions --- #
func _init(init_entity: Entity = null, init_stacks: int = 1, init_stage: int = 1) -> void:
	entity = init_entity
	
	stacks = init_stacks
	stage = init_stage
	
	setup_signals()
	set_status_info()

func setup_signals() -> void:
	entity.turn_ended.connect(decrement_stacks)

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
	
	stage = new_stage
	
	if additive:
		set_stacks(stacks + new_stacks)
	else:
		if new_stacks > stacks:
			set_stacks(new_stacks)
	
	set_status_info()

func remove_status() -> void:
	entity.status_effects.queue_removal(key)

func get_icon() -> Texture2D:
	return null

# - Effects - #
#func _on_turn_started(params: Dictionary) -> void:
	#return
#
#func _on_turn_ended(params: Dictionary) -> void:
	#return
#
#func _on_side_changed(params: Dictionary) -> void:
	#return
#
#func _on_take_damage(params: Dictionary) -> void:
	#return
#
#func _on_deal_damage(params: Dictionary) -> void:
	#return
#
#func _on_get_stat(stat: Globals.STAT, params: Dictionary) -> void:
	#return
