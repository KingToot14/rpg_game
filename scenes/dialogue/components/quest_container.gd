class_name QuestContainer
extends Control

# --- Variables --- #
@onready var icon_container := $"panel/icon_container" as HBoxContainer
@onready var panel_rect := $"panel" as Control

# --- References --- #
var quest_info_scene = preload("res://scenes/dialogue/components/item_info.tscn")

# --- Functions --- #
func load_items(tag: StringName) -> void:
	var quest = DataManager.load_quest(tag)
	
	if not quest:
		return
	
	var new_size = panel_rect.size
	new_size.x = 6 + len(quest.requirements) * 28
	panel_rect.set_size(new_size, true)
	
	for item in quest.requirements:
		var quest_info = quest_info_scene.instantiate()
		var inventory_item = DataManager.get_item(item.item_key)
		var curr_count = 0
		
		if inventory_item:
			curr_count = clamp(inventory_item.quantity, 0, item.quantity)
		
		quest_info.get_node("icon").texture = inventory_item.icon
		quest_info.get_node("count").text = "[center]" + str(curr_count) + "/" + str(item.quantity)
		quest_info.get_node("tooltip/label").text = "[center]" + inventory_item.name
		
		icon_container.add_child(quest_info)
