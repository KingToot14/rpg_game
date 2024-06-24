class_name TimedSingleHit
extends Control

# --- Variables --- #
@export var rotation_speed: float = 2.0

var needle_pos: Array[float] = []
var curr_needle: int = 0

var active := false

# --- Constants --- #
const PERF_THRESHOLD: float = 0.10

# --- References --- #
@onready var backing := $"indicator" as TextureRect
var needles: Array[Control] = []

# --- Functions --- #
func _ready() -> void:
	for child in get_children():
		if "needle" in child.name:
			needles.append(child)
	
	visible = false

func _process(delta) -> void:
	if not active:
		return
	
	for i in range(len(needle_pos)):
		needle_pos[i] -= delta
	
		set_needle_rotation(needles[i], 360 - 180 * needle_pos[i] * rotation_speed)
	
	if curr_needle >= len(needle_pos):
		return
	
	if visible and 360 - 180 * needle_pos[curr_needle] * rotation_speed > 360:
		set_result(&'poor')

func _input(event) -> void:
	if not (active and event.is_pressed() and curr_needle < len(needle_pos)):
		return
	if not (event is InputEventKey or event is InputEventMouseButton):
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
	
	needle_pos = timings
	for i in range(len(needle_pos)):
		set_needle_rotation(needles[i], 360 - 180 * needle_pos[i] * rotation_speed)

func set_active() -> void:
	active = true

func set_needle_rotation(needle: Control, rot: float) -> void:
	if needle:
		needle.material.set_shader_parameter('rotation', rot)

func set_result(result: StringName) -> void:
	Globals.timing_mods.append(result)
	Globals.ui_manager.show_timing_result(result)
	
	curr_needle += 1
	
	if curr_needle >= len(needle_pos):
		visible = false
		active = false
