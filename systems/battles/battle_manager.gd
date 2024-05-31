class_name BattleManager
extends Node2D

# --- Variables --- #
@export var players: Array[Entity]
var enemies: Array[Entity]

@export var enemy_positions: Array[Node2D] = [null, null, null, null, null]

# - Encounter Info - #
var encounter: Encounter
var curr_wave: int = 0
var wave_count: int = 0

# --- References --- #
@onready var state_machine = $"state_machine" as BattleFsm
@onready var ui_manager = $"ui" as BattleUiManager

# --- Functions --- #
func _ready():
	AsyncLoader.new(Globals.encounter_resource, setup_encounter)

# - Encounters - #
func setup_encounter(loaded_encounter: Encounter) -> void:
	encounter = loaded_encounter
	
	# Setup players
	# TODO: Enable/Disable players based on party, load correct sprites into party
	for i in range(len(players)):
		var player = players[i]
		player.died.connect(check_state)
		
		# Player ui
		ui_manager.setup_player_hp(player, i)
		ui_manager.setup_player_special(player, i)
	
	# Setup waves
	wave_count = len(encounter.waves)
	load_wave(encounter.waves[curr_wave])
	
	# Start state machine
	state_machine.set_state('player')

# - Wave Loading - #
func load_next_wave() -> bool:
	curr_wave += 1
	
	if curr_wave < wave_count:
		load_wave(encounter.waves[curr_wave])
		return true
	return false

func load_wave(wave: Wave) -> void:
	for i in range(len(wave.enemies)):
		if wave.enemies[i] != "":
			AsyncLoader.new(wave.enemies[i], setup_enemy.bind(i))

# - Entity Management - #
func setup_enemy(enemy_scene: PackedScene, spawn_index: int) -> void:
	var enemy: Entity = enemy_scene.instantiate() as Entity
	enemy.died.connect(check_state)
	enemy.global_position = enemy_positions[spawn_index].global_position
	enemies.append(enemy)
	
	add_child(enemy)

func remove_from_battle(entity: Entity) -> void:
	players.erase(entity)
	enemies.erase(entity)
	
	state_machine.entity_removed(entity)

# - Battle State - #
func check_state() -> void:
	var state = evaluate_state()
	
	match state:
		-1:			# Loss
			state_machine.set_state('lose')
		1:			# Enemies cleared
			print("Enemies cleared!")
			if not load_next_wave():
				state_machine.set_state('win')

func evaluate_state() -> int:		# -1 => lose  |  0 => neither  |  1 => win
	var all_dead = true
	
	# Check if all players are dead
	for player in players:
		if not player:
			continue
		if player.alive:
			all_dead = false
			break
	
	if all_dead:
		return -1
	
	# Check if all enemies are dead
	all_dead = true
	for enemy in enemies:
		if not enemy:
			continue
		if enemy.alive:
			all_dead = false
	
	return 1 if all_dead else 0

# - Scene Management - #
func load_overworld() -> void:
	SceneManager.load_scene(Globals.OVERWORLD_SCENE)
