class_name QuestContainer
extends Control

# --- Variables --- #
@onready var icon_container := $"icon_container" as HBoxContainer

# --- References --- #
var quest_info_scene = preload("res://scenes/dialogue/components/quest_info.tscn")

# --- Functions --- #
func load_items(tag: StringName) -> void:
	var quest = DataManager.load_quest(tag)
	
	if not quest:
		return
	
	var new_size = size
	new_size.x = 6 + len(quest.requirements) * 28
	set_size(new_size, true)
	
	for item in quest.requirements:
		var quest_info = quest_info_scene.instantiate()
		var inventory_item = DataManager.get_item(item.item_key)
		var curr_count = 0
		
		if inventory_item:
			curr_count = clamp(inventory_item.quantity, 0, item.quantity)
		
		quest_info.get_node("count").text = "[center]" + str(curr_count) + "/" + str(item.quantity)
		
		icon_container.add_child(quest_info)
