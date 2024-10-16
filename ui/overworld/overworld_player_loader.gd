class_name OverworldPlayerLoader
extends Node

# --- Variables --- #
var tabs: Array[StringName] = []
var curr_index := 0

# --- Functions --- #
func _ready() -> void:
	# setup signals
	%'melee_tab'.pressed.connect(set_current_player.bind(&'melee'))
	%'ranged_tab'.pressed.connect(set_current_player.bind(&'ranged'))
	%'magic_tab'.pressed.connect(set_current_player.bind(&'magic'))
	%'monk_tab'.pressed.connect(set_current_player.bind(&'monk'))
	
	load_entity_tabs()
	load_curr_player()

func load_curr_player() -> void:
	if curr_index < 0 or curr_index >= len(DataManager.players):
		return
	
	var player = DataManager.players[curr_index]
	
	if player:
		load_player(player)

func set_current_player(tab: StringName) -> void:
	for e_tab: OverworldButton in get_tree().get_nodes_in_group(&'entity_tab'):
		e_tab.set_alternate(e_tab.name != (tab + "_tab"))
	
	curr_index = tabs.find(tab)
	
	print(curr_index)
	
	load_curr_player()

func load_player(player: PlayerDataChunk) -> void:
	if not player:
		return
	
	# load stats
	%'player_hp'.text = "%d" % player.get_max_hp()
	%'player_p_attack'.text = "%.2f" % player.get_p_attack()
	%'player_m_attack'.text = "%.2f" % player.get_m_attack()
	%'player_p_defense'.text = "%.2f" % player.get_p_defense()
	%'player_m_defense'.text = "%.2f" % player.get_m_defense()
	%'player_accuracy'.text = "%.2f" % player.get_accuracy()
	%'player_evasion'.text = "%.2f" % player.get_evasion()
	
	# load name
	%'player_name'.text = player.name
	
	# load description
	%'player_description'.text = player.description
	
	# load xp
	%'player_level'.text = "Level: %d" % player.level
	
	%'total_xp'.text = "%d" % player.curr_xp
	%'next_xp'.text = "%d" % player.xp_to_next
	
	%'xp_fill'.size.x = %'xp_fill'.get_parent().size.x * (1.0 * player.curr_xp / player.xp_to_next)
	
	# load hp
	%'hp_label'.text = "Health: %d/%d" % [player.curr_hp, player.get_max_hp()]
	%'hp_fill'.size.x = %'hp_fill'.get_parent().size.x * (1.0 * player.curr_hp / player.get_max_hp())
	
	%'sp_label'.text = "Special: %d" % player.curr_special + "%"
	%'sp_fill'.size.x = %'sp_fill'.get_parent().size.x * player.curr_special

func load_entity_tabs() -> void:
	for tab in get_tree().get_nodes_in_group(&'entity_tab'):
		tab.hide()
	
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
