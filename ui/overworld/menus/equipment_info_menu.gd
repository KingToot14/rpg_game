class_name EquipmentInfoMenu
extends Control

# --- Variables --- #
var curr_equip: Equipment
var curr_player: PlayerDataChunk

var selecting_new := false

# --- Functions --- #
func load_player(player: PlayerDataChunk) -> void:
	curr_player = player
	
	if player:
		load_weapon(player.weapon)
		load_armor(player.armor)
		load_special(player.special)
	load_equipment(null)

func load_from_player(type: StringName) -> void:
	if not curr_player:
		return
	
	match type:
		&'armor':
			load_equipment(curr_player.armor)
		&'weapon':
			load_equipment(curr_player.weapon)
		&'special':
			load_equipment(curr_player.special)

func load_equipment(equip: Equipment = null) -> void:
	if not equip or equip == curr_equip:
		curr_equip = null
		hide()
		return
	
	curr_equip = equip
	
	show()
	
	%'equipment_backing'.texture = equip.equip_backing
	%'equipment_texture'.texture = equip.equip_texture
	
	%'equipment_name'.text = equip.equip_name
	%'equipment_level'.text = "Level %d" % equip.level
	%'equipment_description'.text = equip.get_description()

func load_weapon(weapon: Equipment) -> void:
	if not weapon:
		return
	
	%'weapon_backing'.texture = weapon.equip_backing
	%'weapon_texture'.texture = weapon.equip_texture
	
	%'weapon_name'.text = weapon.equip_name
	%'weapon_level'.text = "Level %d" % weapon.level

func load_armor(armor: Equipment) -> void:
	if not armor:
		return
	
	%'armor_backing'.texture = armor.equip_backing
	%'armor_texture'.texture = armor.equip_texture
	
	%'armor_name'.text = armor.equip_name
	%'armor_level'.text = "Level %d" % armor.level

func load_special(special: Equipment) -> void:
	if not special:
		return
	
	%'special_backing'.texture = special.equip_backing
	%'special_texture'.texture = special.equip_texture
	
	%'special_name'.text = special.equip_name
	%'special_level'.text = "Level %d" % special.level
