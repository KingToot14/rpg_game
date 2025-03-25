class_name Entity
extends Node2D

# --- Signals --- #
signal entity_setup()
signal entity_entered()

signal side_changed(params: Dictionary)
signal turn_started(params: Dictionary)
signal turn_ended(params: Dictionary)

signal took_damage(params: Dictionary)
signal deal_damage(params: Dictionary)

signal performed_action(param: Dictionary)

signal received_status(params: Dictionary)
signal gave_status(params: Dictionary)

signal getting_stat(stat: Globals.Stat, params: Dictionary)

# --- Variables --- #
@export var display_mode := false
# @@show_if(display_mode)
@export var display_pos: Vector2

@export var entity_name: String
@export_multiline var description: String

var entered := false
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
func _ready() -> void:
	if display_mode:
		$"ui".hide()
		position = display_pos
		
		animator.play_idle_anim()
		
		setup(0)

func setup(index: int):
	spawn_index = index
	
	var manager_root = get_node_or_null(^'managers')
	
	if not manager_root:
		return
	
	# setup children
	for child in manager_root.get_children():
		if 'setup' in child:
			child.setup(self)
	
	# setup z order
	z_index = 100 + spawn_index * 10
	
	await get_tree().process_frame
	
	entity_setup.emit()

func finish_entered_battle() -> void:
	entered = true
	entity_entered.emit()

func store_data() -> void:
	if hp:
		hp.store_hp()
	if special:
		special.store_special()

func is_player() -> bool:
	return is_in_group(&'player')

#region Player Equipment
func reload_equips() -> void:
	$'managers/equipment'.reload()

func get_weapon_element() -> Attack.Element:
	return $'managers/equipment'.weapon.element

#endregion

func remove_from_battle() -> void:
	Globals.encounter_manager.remove_from_battle(self, spawn_index)

# - Positioning - #
func get_front_pos() -> Vector2:
	return front_marker.global_position
