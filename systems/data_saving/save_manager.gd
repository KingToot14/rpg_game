extends Node

# --- Variables --- #
var curr_slot := 1

# --- Constants --- #
const SAVE_FOLDER := 'user://saves'

# --- Functions --- #
func save_game() -> void:
	# make sure save dir exists
	make_save_directory()
	
	# store data
	var file = FileAccess.open(get_save_path(), FileAccess.WRITE)
	
	file.store_var(DataManager.get_save_data())
	file.close()

func get_save() -> Dictionary:
	var file = FileAccess.open(get_save_path(), FileAccess.READ)
	
	if file.get_position() < file.get_length():
		return file.get_var()
	else:
		return {}

func make_save_directory() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_FOLDER):
		DirAccess.make_dir_absolute(SAVE_FOLDER)

func get_save_path() -> String:
	return SAVE_FOLDER + "/" + get_save_file_name()

func get_save_file_name() -> String:
	return "slot_" + str(curr_slot) + ".save"
