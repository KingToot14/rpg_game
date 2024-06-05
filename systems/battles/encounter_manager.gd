class_name EncounterManager
extends Node2D

# --- Signals --- #
signal encounter_victory()

# --- Variables --- #
@export_file("*.tscn") var melee_path: String
@export_file("*.tscn") var ranged_path: String
@export_file("*.tscn") var healer_path: String
@export_file("*.tscn") var magic_path: String

@export var player_positions: Array[Node2D] = [null, null, null, null]
@export var enemy_positions: Array[Node2D] = [null, null, null, null, null]

# - Encounter Info - #
var encounter: Encounter
var curr_wave: int = 0
var wave_count: int = 0

# --- References --- #
@onready var turn_fsm = $"turn_fsm" as TurnFSM
@onready var action_fsm = $"action_fsm" as ActionFSM
@onready var ui_manager = $"ui" as BattleUiManager

# --- Functions --- #
func _ready():
	Globals.encounter_manager = self
	
	AsyncLoader.new(Globals.encounter_resource, setup_encounter)

# - Encounters - #
func setup_encounter(loaded_encounter: Encounter) -> void:
	encounter = loaded_encounter
	encounter_victory.connect(encounter.handle_victory)
	
	# Setup players
	for i in range(4):
		match DataManager.players[i].role:
			PlayerDataChunk.PlayerRole.NONE:
				ui_manager.setup_player_hp(null, i)
			PlayerDataChunk.PlayerRole.MELEE:
				AsyncLoader.new(melee_path, setup_entity.bind(i))
			PlayerDataChunk.PlayerRole.RANGED:
				AsyncLoader.new(ranged_path, setup_entity.bind(i))
			PlayerDataChunk.PlayerRole.HEALER:
				AsyncLoader.new(healer_path, setup_entity.bind(i))
			PlayerDataChunk.PlayerRole.MAGIC:
				AsyncLoader.new(magic_path, setup_entity.bind(i))
	
	# Setup waves
	wave_count = len(encounter.waves)
	load_wave(encounter.waves[curr_wave])
	
	# Start state machine
	turn_fsm.set_state('player')

# - Wave Loading - #
func load_next_wave() -> bool:
	curr_wave += 1
	
	if curr_wave < wave_count:
		load_wave(encounter.waves[curr_wave])
		return true
	return false

func load_wave(wave: Wave) -> void:
	ui_manager.update_wave_counter(curr_wave + 1, wave_count)
	
	for i in range(len(wave.enemies)):
		if wave.enemies[i] != "":
			AsyncLoader.new(wave.enemies[i], setup_entity.bind(i))
		else:
			ui_manager.setup_enemy_hp(null, i)

# - Entity Management - #
func setup_entity(entity_scene: PackedScene, spawn_index: int) -> void:
	var entity := entity_scene.instantiate() as Entity
	
	# Signals
	entity.died.connect(check_state)
	entity.selected.connect(action_fsm.entity_selected)
	
	# UI
	if entity.is_player:
		encounter_victory.connect(entity.store_data)
		entity.global_position = player_positions[spawn_index].global_position
		ui_manager.setup_player_hp(entity, spawn_index)
		ui_manager.setup_player_special(entity, spawn_index)
	else:
		entity.global_position = enemy_positions[spawn_index].global_position
		ui_manager.setup_enemy_hp(entity, spawn_index)
	
	add_child(entity)

func remove_from_battle(entity: Entity, index: int) -> void:
	ui_manager.setup_enemy_hp(null, index)
	turn_fsm.entity_removed(entity)

# - Battle State - #
func check_state() -> void:
	var state = evaluate_state()
	
	match state:
		-1:			# Loss
			turn_fsm.set_state('lose')
		1:			# Enemies cleared
			print("Enemies cleared!")
			if not load_next_wave():
				turn_fsm.set_state('win')

func evaluate_state() -> int:		# -1 => lose  |  0 => neither  |  1 => win
	var all_dead = true
	
	# Check if all players are dead
	var players = TargetingHelper.get_entities(&'player')
	for player: Entity in players:
		if player and player.alive:
			all_dead = false
			break
	
	if all_dead:
		return -1
	
	# Check if all enemies are dead
	all_dead = true
	var enemies = TargetingHelper.get_entities(&'enemy')
	for enemy: Entity in enemies:
		if enemy and enemy.alive:
			all_dead = false
	
	return 1 if all_dead else 0

func handle_victory() -> void:
	encounter_victory.emit()

# - Scene Management - #
func load_overworld() -> void:
	SceneManager.load_scene(Globals.OVERWORLD_SCENE)
