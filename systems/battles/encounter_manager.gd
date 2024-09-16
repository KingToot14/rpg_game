class_name EncounterManager
extends Node2D

# --- Signals --- #
signal encounter_victory()
signal encounter_loss()

# --- Variables --- #
var total_loot: Array[InventoryItem] = []
var total_xp: int

@export_group("Player Paths")
@export_file("*.tscn") var melee_path: String
@export_file("*.tscn") var ranged_path: String
@export_file("*.tscn") var healer_path: String
@export_file("*.tscn") var magic_path: String

@export_group("Timing")
@export var spawn_delay: float = 0.25
@export var wave_delay: float = 0.25

# - Encounter Info - #
var encounter: Encounter
var curr_wave: int = 0
var wave_count: int = 0

# --- References --- #
@onready var turn_fsm = %"turn_fsm" as TurnFSM
@onready var action_fsm = %"action_fsm" as ActionFSM
@onready var ui_manager = %"ui" as BattleUiManager

# --- Functions --- #
func _ready():
	Globals.encounter_manager = self
	
	# Signals
	encounter_victory.connect(store_loot)
	encounter_victory.connect(store_xp)
	
	AsyncLoader.new(Globals.encounter_resource, setup_encounter)
	
	# Reveal battle
	TransitionManager.reset_all()
	TransitionManager.end_split()

# - Encounters - #
func setup_encounter(loaded_encounter: Encounter) -> void:
	encounter = loaded_encounter
	encounter_victory.connect(encounter.handle_victory)
	
	# Setup players
	for i in range(4):
		if not DataManager.players[i]:
			ui_manager.setup_player_hp(null, i)
			continue
		
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
	await get_tree().create_timer(wave_delay).timeout
	
	ui_manager.update_wave_counter(curr_wave + 1, wave_count)
	
	var paths: Array[String] = []
	for enemy in wave.enemies:
		if enemy:
			paths.append(enemy.entity_path)
		else:
			paths.append("")
	
	BatchLoader.new(paths, setup_wave)

func setup_wave(enemies: Array) -> void:
	for i in range(len(enemies)):
		if enemies[i]:
			setup_entity(enemies[i], i)
			await get_tree().create_timer(spawn_delay).timeout
		else:
			ui_manager.setup_enemy_hp(null, i)

# - Entity Management - #
func setup_entity(entity_scene: PackedScene, spawn_index: int) -> void:
	var entity := entity_scene.instantiate() as Entity
	var spawn_pos: Node2D

	if entity.is_player():
		entity.level = DataManager.players[spawn_index].level
		spawn_pos = %'player_positions'.get_child(spawn_index)
	else:
		entity.level = encounter.waves[curr_wave].enemies[spawn_index].level
		spawn_pos = %'enemy_positions'.get_child(spawn_index)
	
	# position
	var item = encounter.waves[curr_wave].enemies[spawn_index] as WaveItem
	if item and item.use_custom_position:
		spawn_pos.global_position = item.position
	
	spawn_pos.add_child(entity)
	entity.position = Vector2.ZERO
	
	# visibility
	entity.visible = false
	entity.setup(spawn_index)
	
	await entity.entity_setup
	
	# Signals
	entity.targeting.selected.connect(action_fsm.entity_selected)
	
	if entity.is_player():
		encounter_victory.connect(entity.store_data)
		ui_manager.setup_player_hp(entity, spawn_index)
	else:
		ui_manager.setup_enemy_hp(entity, spawn_index)

func remove_from_battle(entity: Entity, index: int) -> void:
	ui_manager.setup_enemy_hp(null, index)
	turn_fsm.entity_removed(entity)

# - Battle State - #
func evaluate_state() -> int:		# -1 => lose  |  0 => neither  |  1 => win
	var all_dead = true
	
	# Check if all players are dead
	var players = TargetingHelper.get_entities(&'player')
	for player: Entity in players:
		if player and player.hp.alive:
			all_dead = false
			break
	
	if all_dead:
		return -1
	
	# Check if all enemies are dead
	all_dead = true
	var enemies = TargetingHelper.get_entities(&'enemy')
	for enemy: Entity in enemies:
		if enemy and enemy.hp.alive:
			all_dead = false
	
	return 1 if all_dead else 0

func handle_victory() -> void:
	encounter_victory.emit()

func handle_loss() -> void:
	encounter_loss.emit()

# - Scene Management - #
func load_overworld() -> void:
	var wait_time = TransitionManager.play_split()
	Globals.from_battle = true
	await get_tree().create_timer(wait_time).timeout
	SceneManager.load_scene(Globals.OVERWORLD_SCENE)

# - Items - #
func add_items(items: Array[InventoryItem]) -> void:
	total_loot.append_array(items)

func add_xp(xp: int) -> void:
	total_xp += xp

func store_loot() -> void:
	for loot in total_loot:
		DataManager.add_to_inventory(loot)

func store_xp() -> void:
	# Push xp to victory panel
	Globals.ui_manager.victory_panel.show_xp(total_xp)
