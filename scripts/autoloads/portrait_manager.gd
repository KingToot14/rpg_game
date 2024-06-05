extends Node

# --- Variables --- #
var curr_portrait: Texture2D

# --- Functions --- #
func set_portrait(npc: NpcInformation, mood: String = ""):
	if npc:
		curr_portrait = npc.portrait_texture
	else:
		curr_portrait = null
