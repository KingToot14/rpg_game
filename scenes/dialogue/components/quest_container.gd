class_name QuestContainer
extends Control

# --- Variables --- #
@onready var icon_container := %"icon_container" as HBoxContainer
@onready var panel_rect := $"panel" as Control

# --- Functions --- #
func load_items(tag: StringName) -> void:
	var quest := DataManager.load_quest(tag) as Quest
	
	if not quest:
		return
	
	var new_size = panel_rect.size
	new_size.x = 6 + len(quest.requirements) * 28
	panel_rect.set_size(new_size, true)
	
	for i in range(icon_container.get_child_count()):
		var container = icon_container.get_child(i)
		
		container.visible = i < len(quest.requirements)
		
		if not container.visible:
			continue
		
		var quest_item = quest.requirements[i]
		var inventory_item = DataManager.get_item(quest_item.item_key)
		
		icon_container.get_child(i).set_item_target(inventory_item, quest_item.quantity)
