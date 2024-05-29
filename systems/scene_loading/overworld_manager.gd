class_name OverworldManager
extends Node2D

# --- Signals --- #
signal area_loaded()

# --- Variables --- #
var current_area: AreaInformation

# --- Functions --- #
@onready var player: OverworldController = $"player"

# --- Functions --- #
func _ready() -> void:
	Globals.overworld_manager = self
	
	AsyncLoader.new(Globals.overworld_area, add_area)

func load_direction(direction: String) -> void:
	var path: String = ""
	
	match direction:
		'top':
			path = current_area.top_area
		'bottom':
			path = current_area.bottom_area
		'left':
			path = current_area.left_area
		'right':
			path = current_area.right_area
		_:
			printerr(direction, " is not a valid direction")
			return
	
	if path != "":
		player.prepare_transition(direction)
		AsyncLoader.new(path, add_area)

func load_battle(battle_path: String) -> void:
	player.prepare_battle()
	SceneManager.load_scene(battle_path)

func add_area(scene: PackedScene):
	Globals.overworld_area = scene.resource_path
	
	if current_area:
		current_area.queue_free()
	current_area = scene.instantiate()
	add_child(current_area)
	
	area_loaded.emit()
