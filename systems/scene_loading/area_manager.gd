class_name AreaManager
extends Node2D

# --- Variables --- #
@export_file("*.tscn") var top_area: String
@export_file("*.tscn") var bottom_area: String
@export_file("*.tscn") var left_area: String
@export_file("*.tscn") var right_area: String

var loading: bool = false

# --- Functions --- #
func load_direction(direction: String) -> void:
	if loading:
		return
	
	var path: String = ""
	
	match direction:
		'top':
			path = top_area
		'bottom':
			path = bottom_area
		'left':
			path = left_area
		'right':
			path = right_area
		_:
			printerr(direction, " is not a valid direction")
			return
	
	if path != "":
		SceneManager.load_scene(path)
