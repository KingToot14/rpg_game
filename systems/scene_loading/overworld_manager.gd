class_name OverworldManager
extends Node2D

# --- Signals --- #
signal area_loaded()
signal area_changed()

# --- Variables --- #
var current_area: AreaInformation

# --- Functions --- #
@onready var player: OverworldController = $"player"

# --- Functions --- #
func _ready() -> void:
	Globals.overworld_manager = self
	area_changed.connect(DataManager.clear_local_area)
	
	if Globals.from_battle:
		Globals.from_battle = false
		TransitionManager.reset_all()
		TransitionManager.end_split()
	
	AsyncLoader.new(Globals.overworld_area, add_area)

func load_direction(direction: String) -> void:
	var path := ""
	var dir := Vector2.ZERO
	
	match direction:
		'top':
			path = current_area.top_area
			dir.y = 1.0
		'bottom':
			path = current_area.bottom_area
			dir.y = -1.0
		'left':
			path = current_area.left_area
			dir.x = 1.0
		'right':
			path = current_area.right_area
			dir.x = -1.0
		_:
			printerr(direction, " is not a valid direction")
			return
	
	if path != "":
		var wait_time = TransitionManager.play_swipe(dir)
		await get_tree().create_timer(wait_time).timeout
		area_changed.emit()
		player.prepare_transition(direction)
		AsyncLoader.new(path, add_area)

func load_battle(battle_path: String) -> void:
	var wait_time = TransitionManager.play_circle()
	await get_tree().create_timer(wait_time).timeout
	player.prepare_battle()
	SceneManager.load_scene(battle_path)

func add_area(scene: PackedScene):
	Globals.overworld_area = scene.resource_path
	DataManager.set_local_path(scene.resource_path)
	
	if current_area:
		current_area.queue_free()
	current_area = scene.instantiate()
	add_child(current_area)
	
	TransitionManager.end_swipe()
	area_loaded.emit()
