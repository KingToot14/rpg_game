class_name PartyManager
extends Control

# --- Variables --- #
var curr_index := 1

# --- Functions --- #
func set_melee_position(index: int) -> void:
	swap_members(index, curr_index)
	curr_index = index

func swap_members(index_1: int, index_2: int) -> void:
	var temp = DataManager.players[index_1]
	DataManager.players[index_1] = DataManager.players[index_2]
	DataManager.players[index_2] = temp
