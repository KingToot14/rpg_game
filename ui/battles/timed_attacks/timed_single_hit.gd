class_name TimedSingleHit
extends Control

# --- Variables --- #
@export var rotation_speed: float = 2.0

var needle_pos: Array[float] = []
var curr_needle: int = 0

# --- Constants --- #
const POOR_MULT: float = 0.90
const GOOD_MULT: float = 1.00
const PERF_MULT: float = 1.50

const PERF_THRESHOLD: float = 0.10

# --- References --- #
@onready var backing := $"indicator" as TextureRect
var needles: Array[Control] = []

# --- Functions --- #
func _ready() -> void:
	for child in get_children():
		if "needle" in child.name:
			needles.append(child)

func _process(delta) -> void:
	for i in range(len(needle_pos)):
		needle_pos[i] -= delta
	
		set_needle_rotation(needles[i], 360 - 180 * needle_pos[i] * rotation_speed)
	
	if visible and 360 - 180 * needle_pos[curr_needle] * rotation_speed > 360:
		set_result(&'poor')

func _input(event) -> void:
	if not (visible and event is InputEventKey and event.is_pressed()):
		return
	
	if needle_pos[curr_needle] < PERF_THRESHOLD:
		set_result(&'perfect')
	elif needle_pos[curr_needle] > 0:
		set_result(&'good')
	else:
		set_result(&'poor')

func setup_timing(timings: Array[float]) -> void:
	backing.material.set_shader_parameter('threshold', PERF_THRESHOLD * rotation_speed)
	curr_needle = 0
	
	print(timings)
	
	needle_pos = timings
	for i in range(len(needle_pos)):
		set_needle_rotation(needles[i], 360 - 180 * needle_pos[i] * rotation_speed)

func set_needle_rotation(needle: Control, rot: float) -> void:
	if needle:
		needle.material.set_shader_parameter('rotation', rot)

func set_result(result: StringName) -> void:
	match result:
		&'perfect':
			Globals.timing_mods.append(PERF_MULT)
		&'good':
			Globals.timing_mods.append(GOOD_MULT)
		&'poor':
			Globals.timing_mods.append(POOR_MULT)
	
	Globals.ui_manager.show_timing_result(result)
	
	print(curr_needle, ": ", result)
	
	curr_needle += 1
	
	if curr_needle >= len(needle_pos):
		visible = false
