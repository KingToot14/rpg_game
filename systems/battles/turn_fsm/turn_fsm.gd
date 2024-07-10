class_name TurnFSM
extends Node2D

# --- Signals --- #
signal turn_started()

signal state_changed(state: String)

# --- Variables --- #
var curr_state: TurnState

@export var turn_switch_delay: float = 0.0

# --- Functions --- #
func _ready() -> void:
	Globals.turn_fsm = self
	Globals.item_set.connect(item_set)

func set_state(state: String) -> void:
	if not has_node(state + "_state"):
		return
	
	await get_tree().create_timer(turn_switch_delay).timeout
	
	if curr_state:
		curr_state.state_exited()
	
	curr_state = get_node(state + "_state") as TurnState
	curr_state.state_entered()
	
	state_changed.emit(state)

func set_side(_side: String) -> void:
	pass

func find_next_turn() -> void:
	Globals.curr_entity = get_next_entity()
	
	var battle_state = Globals.encounter_manager.evaluate_state()
	
	if battle_state == -1:
		set_state('lose')
		return
	elif battle_state == 1:
		print("All defeated!")
		
		# make sure nothing is in the process of dying
		var entities = TargetingHelper.get_entities(&'enemy')
		for i in range(5):
			for entity in entities:
				if entity.spawn_index != i:
					continue
				if is_instance_valid(entity) and not entity.hp.alive:
					await entity.hp.died
		
		if not Globals.encounter_manager.load_next_wave():
			set_state('win')
			return
	
	if Globals.curr_entity:
		start_turn()
		Globals.curr_entity.turn.take_turn()
	else:
		set_state(curr_state.next_state)

func set_entity(entity: Entity) -> void:
	Globals.curr_entity = entity
	start_turn()
	Globals.curr_entity.turn.take_turn()
	Globals.action_fsm.set_state("blank")

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

func item_set() -> void:
	curr_state.item_set()

func entity_removed(entity: Entity) -> void:
	curr_state.entity_removed(entity)

func action_performed() -> void:
	curr_state.action_performed()
