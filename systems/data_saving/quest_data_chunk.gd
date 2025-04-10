class_name QuestDataChunk
extends Resource

# --- Variables --- #
var quest_path: String
var completed: bool = false

# --- Functions --- #
func _init(load_info = null) -> void:
	if not load_info:
		load_info = {}
	
	quest_path = load_info.get('quest_path', "")
	completed = load_info.get('completed', false)

func get_save_data() -> Dictionary:
	return {
		'quest_path': 	quest_path,
		'completed': 	completed
	}

func get_status() -> bool:
	var quest = load(quest_path) as Quest
	
	for item in quest.requirements:
		if not DataManager.has_item(item):
			return false
	
	return true

func set_status(val: bool) -> void:
	completed = val
	
	if completed:
		var quest = load(quest_path) as Quest
		quest.pay_and_collect()
