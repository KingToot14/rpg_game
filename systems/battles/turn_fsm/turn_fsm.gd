class_name TurnFSM
extends Node2D

# --- Signals --- #
signal turn_started()

signal state_changed(state: String)

# --- Variables --- #
var curr_state: TurnState

var busy_count := 0

@export var turn_switch_delay: float = 0.0

# --- Functions --- #
func _ready() -> void:
	Globals.turn_fsm = self

func set_state(state: String) -> void:
	if not has_node(state + "_state"):
		return
	
	await get_tree().create_timer(turn_switch_delay).timeout
	
	if curr_state:
		curr_state.state_exited()
	
	curr_state = get_node(state + "_state") as TurnState
	curr_state.state_entered()
	
	state_changed.emit(state)

#region Entity Management
func find_next_turn() -> void:
	var battle_state = Globals.encounter_manager.evaluate_state()
	
	if battle_state == -1:
		set_state('lose')
		return
	elif battle_state == 1:
		if not Globals.encounter_manager.load_next_wave():
			set_state('win')
			return
	
	var entity = get_next_entity()
	
	if entity:
		start_turn()
		entity.turn.take_turn()
	else:
		set_state(curr_state.next_state)

func set_entity(entity: Entity) -> void:
	entity.turn.take_turn()

func get_next_entity() -> Entity:
	var i = 0
	var group = TargetingHelper.get_entities(curr_state.group_name)
	var group_size = len(group)
	
	if group_size <= 0:
		return null
	
	var entity: Entity = null
	while i < group_size:
		entity = group[i]
		if is_instance_valid(entity) and entity.turn.can_act():
			return entity
		
		i += 1
	
	return null

func start_turn() -> void:
	turn_started.emit()

#endregion

#region Busy System
func add_busy() -> void:
	busy_count += 1

func remove_busy() -> void:
	busy_count -= 1
	
	if busy_count <= 0:
		find_next_turn()

#endregion

func entity_removed(entity: Entity) -> void:
	curr_state.entity_removed(entity)

func action_performed() -> void:
	curr_state.action_performed()
