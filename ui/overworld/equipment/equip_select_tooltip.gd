class_name EquipSelectTooltip
extends Tooltip

# --- Variables --- #


# --- Functions --- #
func load_equipment(player: PlayerDataChunk, id: StringName) -> void:
	curr_id = id
	
	# load equipment
	var equips = []
	
	match id:
		&'weapon':
			for weapon in DataManager.weapons:
				if DataManager.weapons[weapon].get(&'role') == player.role:
					equips.append(DataManager.weapons[weapon])
		&'primary':
			for outfit in DataManager.outfits:
				equips.append(DataManager.outfits[outfit].get(&'primary'))
		&'secondary':
			for outfit in DataManager.outfits:
				equips.append(DataManager.outfits[outfit].get(&'secondary'))
		&'trinket':
			for trinket in DataManager.trinkets:
				equips.append(DataManager.trinkets[trinket])
	
	var boxes = get_equip_boxes()
	for i in range(len(boxes)):
		if i >= len(equips):
			boxes[i].hide()
			continue
		else:
			boxes[i].show()
		
		boxes[i].load_equipment(load(equips[i].get(&'path')))

func get_equip_boxes() -> Array[Control]:
	var boxes: Array[Control] = []
	
	for child in get_children():
		if child.name.begins_with("equip"):
			boxes.append(child)
	
	return boxes
