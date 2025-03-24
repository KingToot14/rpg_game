class_name StatusEffect
extends Resource

# --- Variables --- #
var entity: Entity = null

var name = "Effect"
var description = "Description"
var icon_pos = Vector2(0, 0)

var key: StringName = &'key'
var status_type: Globals.StatusType = Globals.StatusType.EMPTY

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

#region Status Info
func setup_signals() -> void:
	entity.turn_ended.connect(decrement_stacks)

func set_status_info() -> void:
	return

#endregion

#region Stacks
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

#endregion

func remove_status() -> void:
	entity.status_effects.remove_effect(key)

func get_icon() -> Texture2D:
	return Globals.load_status_effect_icon(icon_pos.x * 10, icon_pos.y * 10)
