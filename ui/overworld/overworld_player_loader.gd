class_name OverworldPlayerLoader
extends Node

# --- Variables --- #
var tabs: Array[StringName] = []
var curr_index := 0

# --- Functions --- #
func _ready() -> void:
	# setup signals
	for key in [&'melee', &'ranged', &'magic', &'monk']:
		var tab := get_node('%' + key + '_tab')
		tab.pressed.connect(set_current_player.bind(key))
		tab.get_node("left_button").pressed.connect(move_current_player.bind(-1))
		tab.get_node("right_button").pressed.connect(move_current_player.bind(1))
	
	load_entity_tabs()
	set_current_player(tabs[0])
	load_curr_player()

func load_curr_player() -> void:
	if curr_index < 0 or curr_index >= len(DataManager.players):
		return
	
	var player = DataManager.players[curr_index]
	
	if player:
		for node in get_tree().get_nodes_in_group(&'player_menu'):
			if 'load_player' in node:
				node.load_player(player)

func set_current_player(tab: StringName) -> void:
	curr_index = tabs.find(tab)
	
	for e_tab: OverworldButton in get_tree().get_nodes_in_group(&'entity_tab'):
		var active := e_tab.name == (tab + "_tab")
		e_tab.set_alternate(!active)
		(e_tab.get_node("left_button") as CanvasItem).visible = active and curr_index > 0
		(e_tab.get_node("right_button") as CanvasItem).visible = active and (curr_index < len(DataManager.players) - 1 and tabs[curr_index + 1] != &'none')
	
	load_curr_player()

func move_current_player(direction: int) -> void:
	var new_index = curr_index + direction
	if new_index < 0 or new_index >= len(DataManager.players):
		return
	if tabs[new_index] == &'none':
		return
	
	# swap entity indexes
	DataManager.swap_players(curr_index, new_index)
	curr_index = new_index
	
	load_entity_tabs()
	set_current_player(tabs[curr_index])

func load_entity_tabs() -> void:
	for tab in get_tree().get_nodes_in_group(&'entity_tab'):
		tab.hide()
	
	tabs = []
	
	for player in DataManager.players:
		if not player:
			tabs.append(&'none')
			continue
		
		match player.role:
			PlayerDataChunk.PlayerRole.MELEE:
				tabs.append(&'melee')
				%'melee_tab'.show()
			PlayerDataChunk.PlayerRole.RANGED:
				tabs.append(&'ranged')
				%'ranged_tab'.show()
			PlayerDataChunk.PlayerRole.MAGIC:
				tabs.append(&'magic')
				%'magic_tab'.show()
			PlayerDataChunk.PlayerRole.MONK:
				tabs.append(&'monk')
				%'monk_tab'.show()
	
	# update tab order
	for i in range(len(tabs)):
		if tabs[i] == &'none':
			return
		
		%"entity_tabs".move_child(get_node("%" + tabs[i] + "_tab"), i)
