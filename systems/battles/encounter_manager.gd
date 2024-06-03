class_name EncounterManager
extends Node2D

# --- Variables --- #
@export var player_count: int = 1
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
	AsyncLoader.new(Globals.encounter_resource, setup_encounter)

# - Encounters - #
func setup_encounter(loaded_encounter: Encounter) -> void:
	encounter = loaded_encounter
	
	# Setup players
	# TODO: Enable/Disable players based on party, load correct sprites into party
	var players = TargetingHelper.get_entities(&'player')
	for i in range(len(players)):
		if i >= player_count:
			players[i].queue_free()
			ui_manager.setup_player_hp(null, i)
			continue
		
		var player: Entity = players[i]
		# Signals
		player.died.connect(check_state)
		player.selected.connect(action_fsm.entity_selected)
		
		# Player UI
		ui_manager.setup_player_hp(player, i)
		ui_manager.setup_player_special(player, i)
	
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
			AsyncLoader.new(wave.enemies[i], setup_enemy.bind(i))
		else:
			ui_manager.setup_enemy_hp(null, i)

# - Entity Management - #
func setup_enemy(enemy_scene: PackedScene, spawn_index: int) -> void:
	var enemy: Entity = enemy_scene.instantiate() as Entity
	enemy.global_position = enemy_positions[spawn_index].global_position
	#enemies.append(enemy)
	
	# Signals
	enemy.died.connect(check_state)
	enemy.selected.connect(action_fsm.entity_selected)
	
	# UI
	ui_manager.setup_enemy_hp(enemy, spawn_index)
	
	add_child(enemy)

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

# - Scene Management - #
func load_overworld() -> void:
	SceneManager.load_scene(Globals.OVERWORLD_SCENE)
