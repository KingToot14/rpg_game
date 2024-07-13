extends Node

# --- Variables --- #
var players: Array[PlayerDataChunk] = [null, null, null, null]

var local_area: LocalAreaChunk = LocalAreaChunk.new()
var areas = {}

var quests = {}

@export var inventory: Array[ItemDataChunk] = []

var options := OptionsDataChunk.new()

# --- Functions --- #
func _ready() -> void:
	load_from_save()

func get_save_data() -> Dictionary:
	var data = {}
	
	# player data
	var player_data = []
	for player in players:
		if player:
			player_data.append(player.get_save_data())
		else:
			player_data.append(null)
	
	data['players'] = player_data
	
	# local area
	if local_area:
		data['local_area'] = local_area.get_save_data()
	
	# area chunk
	var area_data = {}
	
	for key in areas:
		area_data[key] = areas[key].get_save_data()
	
	data['areas'] = area_data
	
	# quests
	var quest_data = {}
	
	for key in quests:
		quest_data[key] = quests[key].get_save_data()
	
	data['quests'] = quest_data
	
	# inventory
	var inventory_data = []
	
	for item in inventory:
		inventory_data.append(item.get_save_data())
	
	data['inventory'] = inventory_data
	
	return data

func load_from_save() -> void:
	var data = SaveManager.get_save()
	
	# - Player Data
	players = [null, null, null, null]
	
	if 'players' in data:
		var player_data = data['players']
		
		for i in range(4):
			if i >= len(player_data):
				break
			
			players[i] = PlayerDataChunk.new(player_data[i])
	else:
		players = [PlayerDataChunk.new(), null, null, null]
		
		players[0].create_new(PlayerDataChunk.PlayerRole.MELEE)
		players[0].set_appearance("pastel_purple")
	
	# - Local Area
	local_area = LocalAreaChunk.new(data.get('local_area'))
	
	# - Areas
	var area_data = data.get('areas', {})
	
	areas = {}
	for key in area_data:
		areas[key] = AreaDataChunk.new(area_data.get(key, null))
	
	# - Quests
	var quest_data = data.get('quests', {})
	
	quests = {}
	for key in quest_data:
		quests[key] = QuestDataChunk.new(quest_data.get(key, null))
	
	# - Inventory
	var inventory_data = data.get('inventory', [])
	
	for item in inventory:
		item.quantity = 0
	
	for item in inventory_data:
		add_to_inventory(InventoryItem.new(item.get('key', &"twig"), item.get('quantity', 0)))

#region Local Area
# - Local Area - #
func clear_local_area() -> void:
	local_area = LocalAreaChunk.new()

func set_local_path(path: String) -> void:
	local_area.set_area_path(path)
#endregion

#region Area
# - Area - #
func create_area_chunk(key: String = "") -> void:
	if key.is_empty():
		areas[local_area.name] = AreaDataChunk.new()
	else:
		areas[key] = AreaDataChunk.new()

func get_area_chunk(key: String) -> AreaDataChunk:
	key = local_area.name if key.is_empty() else key
	if key in areas:
		return areas[key]
	create_area_chunk(key)
	return areas[key]
#endregion

#region Chests
# - Chests - #
func open_chest(key: String, area_name: String = "") -> void:
	get_area_chunk(area_name).open_chest(key)

func is_open(key: String, area_name: String = "") -> bool:
	return get_area_chunk(area_name).is_open(key)
#endregion

#region Encounters
# - Encounters - #
func add_victory(key: String, area_name: String = "") -> void:
	get_area_chunk(area_name).add_victory(key)

func is_defeated(key: String, area_name: String = "") -> bool:
	return get_area_chunk(area_name).is_defeated(key)
#endregion

#region Puzzles
# - Puzzles - #
func solve_puzzle(key: String, area_name: String = "") -> void:
	get_area_chunk(area_name).solve_puzzle(key)

func is_solved(key: String, area_name: String = "") -> bool:
	return get_area_chunk(area_name).is_solved(key)
#endregion

#region Dialogue
# - Dialogue - #
func get_dialogue_state(key: String, area_name: String = "") -> String:
	return get_area_chunk(area_name).get_dialogue_state(key)

func set_dialogue_state(key: String, state: String, area_name: String = "") -> void:
	get_area_chunk(area_name).set_dialogue_state(key, state)
#endregion

#region Inventories
func add_to_inventory(item: InventoryItem) -> void:
	var inventory_item = get_item(item.item_key)
	
	if inventory_item:
		inventory_item.quantity += item.quantity
	else:
		printerr("No item \'", item.item_key, "\' found in inventory")

func remove_from_inventory(item: InventoryItem) -> void:
	var inventory_item = get_item(item.item_key)
	
	if inventory_item:
		inventory_item.quantity -= item.quantity
	else:
		printerr("No item \'", item.item_key, "\' found in inventory")

func get_item(key: StringName) -> ItemDataChunk:
	for item in inventory:
		if item.key == key:
			return item
	
	return null

func get_inventory(key: StringName) -> Array[ItemDataChunk]:
	var list: Array[ItemDataChunk] = []
	
	for item in inventory:
		if item.inventory == key:
			list.append(item)
	
	return list

func has_item(item: InventoryItem) -> bool:
	var inventory_item = get_item(item.item_key)
	
	return inventory_item and inventory_item.quantity >= item.quantity

func has_item_list(item_list: Array[InventoryItem]) -> bool:
	for item in item_list:
		if not has_item(item):
			return false
	
	return false
#endregion

#region Quests
func start_quest(key: StringName, path: String) -> void:
	quests[key] = QuestDataChunk.new()
	quests[key].quest_path = path

func load_quest(key: StringName) -> Quest:
	if key in quests:
		return load(quests[key].quest_path)
	
	return null

func get_quest_status(key: StringName) -> bool:
	return (key in quests) and quests[key].get_status()

func set_quest_status(key: StringName, val: bool) -> void:
	if key in quests:
		quests[key].set_status(val)
#endregion
