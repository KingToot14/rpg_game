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
@export_file("*.tscn") var monk_path: String
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
@onready var ui_manager = %"ui" as BattleUiManager

# --- Functions --- #
func _ready():
	Globals.encounter_manager = self
	
	# Signals
	encounter_victory.connect(store_loot)
	encounter_victory.connect(store_xp)
	
	AsyncLoader.new(Globals.encounter_resource, setup_encounter)

# - Encounters - #
func setup_encounter(loaded_encounter: Encounter) -> void:
	encounter = loaded_encounter
	encounter_victory.connect(encounter.handle_victory)
	
	# Setup waves
	wave_count = len(encounter.waves)
	load_wave(encounter.waves[curr_wave])

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
	
	# Setup players
	if curr_wave == 0:
		for i in range(4):
			if not DataManager.players[i]:
				paths.append("")
				continue
			
			match DataManager.players[i].role:
				PlayerDataChunk.PlayerRole.MELEE:
					paths.append(melee_path)
				PlayerDataChunk.PlayerRole.RANGED:
					paths.append(ranged_path)
				PlayerDataChunk.PlayerRole.MONK:
					paths.append(monk_path)
				PlayerDataChunk.PlayerRole.MAGIC:
					paths.append(magic_path)
	
	BatchLoader.new(paths, setup_wave.bind(curr_wave == 0))

func setup_wave(entities: Array, first_wave: bool) -> void:
	var delay = spawn_delay
	
	var entity_count = len(entities)
	if first_wave:
		entity_count -= 4
	
	for i in range(entity_count):
		if entities[i]:
			setup_entity(entities[i], i, delay)
			delay += spawn_delay
		else:
			ui_manager.setup_enemy_hp(null, i)
	
	if first_wave:
		delay = spawn_delay
		for i in range(5, len(entities)):
			if entities[i]:
				setup_entity(entities[i], i - 5, delay)
				delay += spawn_delay
			else:
				ui_manager.setup_player_hp(null, i - 5)
		
		turn_fsm.set_state('player')
		
		# Reveal battle
		TransitionManager.reset_all()
		TransitionManager.end_split()

# - Entity Management - #
func setup_entity(entity_scene: PackedScene, spawn_index: int, delay: float) -> void:
	var entity := entity_scene.instantiate() as Entity
	entity.hide()
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
	
	# setup
	entity.setup(spawn_index)
	
	await entity.entity_setup
	
	# Signals
	if entity.is_player():
		encounter_victory.connect(entity.store_data)
		ui_manager.setup_player_hp(entity, spawn_index)
	else:
		ui_manager.setup_enemy_hp(entity, spawn_index)
	
	await get_tree().create_timer(delay).timeout
	
	entity.animator.play_enter_anim()

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
