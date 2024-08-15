class_name Entity
extends Node2D

# --- Signals --- #
signal entity_setup()

# --- Variables --- #
@export var entity_name: String
@export_multiline var description: String

var spawn_index: int
var level: int = 1

# - Components - #
@export var brain: EntityBrain

@export var hp: HpManager
@export var special: SpecialManager

@export var actions: ActionManager

@export var targeting: TargetingManager

@export var stats: StatManager
@export var status_effects: StatusEffectManager

@export var turn: TurnManager

@export var animator: AnimationManager

# - Markers - #
@export var front_marker: Node2D

# --- Functions --- #
func setup(index: int):
	spawn_index = index
	
	var manager_root = get_node_or_null(^'managers')
	
	if not manager_root:
		return
	
	for child in manager_root.get_children():
		if 'setup' in child:
			child.setup(self)
	
	await get_tree().process_frame
	
	entity_setup.emit()

func store_data() -> void:
	if hp:
		hp.store_hp()
	if special:
		special.store_special()

func is_player() -> bool:
	return is_in_group(&'player')

func remove_from_battle() -> void:
	Globals.encounter_manager.remove_from_battle(self, spawn_index)

func action_ended() -> void:
	Globals.action_fsm.perform_action()
	Globals.ui_manager.show_timing('none', null)

# - Positioning - #
func get_front_pos() -> Vector2:
	return front_marker.global_position
