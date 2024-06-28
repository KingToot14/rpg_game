class_name OverworldManager
extends Node2D

# --- Signals --- #
signal area_loaded()
signal area_changed()

# --- Variables --- #
var curr_area: AreaInformation
var curr_transition: StringName

# --- Functions --- #
@onready var player: OverworldController = $"player"

# --- Functions --- #
func _ready() -> void:
	Globals.overworld_manager = self
	area_changed.connect(DataManager.clear_local_area)
	
	if Globals.from_battle:
		Globals.from_battle = false
		curr_transition = &'split'
	
	AsyncLoader.new(Globals.overworld_area, add_area)

func _input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.is_pressed()):
		return
	
	match event.keycode:
		49:		# 1. New Start
			load_area("res://scenes/forest/starting_area/starting_area.tscn")
		50:		# 2. Old start
			load_area("res://scenes/testing/starting_area.tscn")
		51:		# 3. Battle Test
			load_area("res://scenes/testing/starting_area.tscn")

func load_area(path: String, handle_transition := true) -> void:
	if handle_transition:
		var wait_time = TransitionManager.play_circle()
		await get_tree().create_timer(wait_time).timeout
		curr_transition = &'circle'
	
	AsyncLoader.new(path, add_area)

func load_direction(direction: String) -> void:
	var path := ""
	var dir := Vector2.ZERO
	
	match direction:
		'top':
			path = curr_area.top_area
			dir.y = 1.0
		'bottom':
			path = curr_area.bottom_area
			dir.y = -1.0
		'left':
			path = curr_area.left_area
			dir.x = 1.0
		'right':
			path = curr_area.right_area
			dir.x = -1.0
		_:
			printerr(direction, " is not a valid direction")
			return
	
	if path != "":
		var wait_time = TransitionManager.play_swipe(dir)
		await get_tree().create_timer(wait_time).timeout
		area_changed.emit()
		player.prepare_transition(direction)
		curr_transition = &'swipe'
		AsyncLoader.new(path, add_area)

func load_battle(battle_path: String) -> void:
	var wait_time = TransitionManager.play_circle()
	await get_tree().create_timer(wait_time).timeout
	player.prepare_battle()
	SceneManager.load_scene(battle_path)

func add_area(scene: PackedScene):
	Globals.overworld_area = scene.resource_path
	DataManager.set_local_path(scene.resource_path)
	
	if curr_area:
		curr_area.queue_free()
	curr_area = scene.instantiate()
	add_child(curr_area)
	
	TransitionManager.reset_all()
	match curr_transition:
		&'swipe':
			TransitionManager.end_swipe()
		&'circle':
			TransitionManager.end_circle()
		&'split':
			TransitionManager.end_split()
	
	area_loaded.emit()
