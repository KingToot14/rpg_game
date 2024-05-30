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

# - State Info - #
var state

# --- Functions --- #
func _ready():
	AsyncLoader.new(Globals.encounter_resource, setup_encounter)

# - Encounters - #
func setup_encounter(loaded_encounter: Encounter) -> void:
	encounter = loaded_encounter
	
	# Setup players
	# TODO: Enable/Disable players based on party, load correct sprites into party
	for player in players:
		player.died.connect(check_state)
	
	# Setup waves
	wave_count = len(encounter.waves)
	load_wave(encounter.waves[curr_wave])

func load_wave(wave: Wave) -> void:
	for i in range(len(wave.enemies)):
		if wave.enemies[i] != "":
			AsyncLoader.new(wave.enemies[i], setup_enemy.bind(i))

func setup_enemy(enemy_scene: PackedScene, spawn_index: int) -> void:
	var enemy: Entity = enemy_scene.instantiate() as Entity
	enemy.died.connect(check_state)
	enemy.global_position = enemy_positions[spawn_index].global_position
	enemies.append(enemy)
	
	add_child(enemy)

# - Battle State - #
func check_state() -> void:
	var state = evaluate_state()
	
	match state:
		-1:
			print("Loss :()")
			load_overworld()
		1:
			print("Victory :)")
			load_overworld()

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
