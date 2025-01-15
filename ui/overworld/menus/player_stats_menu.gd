class_name PlayerStatsMenu
extends Control

# --- Variables --- #


# --- Functions --- #
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
	
	%'xp_fill'.custom_minimum_size.x = %'xp_fill'.get_parent().size.x * (1.0 * player.curr_xp / player.xp_to_next)
	
	# load hp
	%'hp_label'.text = "Health: %d/%d" % [player.curr_hp, player.get_max_hp()]
	%'hp_fill'.custom_minimum_size.x = %'hp_fill'.get_parent().size.x * (1.0 * player.curr_hp / player.get_max_hp())
	
	%'sp_label'.text = "Special: %d" % player.curr_special + "%"
	%'sp_fill'.custom_minimum_size.x = %'sp_fill'.get_parent().size.x * player.curr_special
