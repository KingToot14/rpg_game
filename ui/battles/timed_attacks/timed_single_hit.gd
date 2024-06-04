class_name TimedSingleHit
extends Control

# --- Variables --- #
@export var rotation_speed: float = 2.0

@export var needles: Array[Node2D] = []
var needle_pos: float = 0.0

# --- Constants --- #
const POOR_MULT: float = 0.90
const GOOD_MULT: float = 1.00
const PERF_MULT: float = 1.50

const PERF_THRESHOLD: float = 0.10

# --- References --- #
@onready var backing := $"indicator" as TextureRect

# --- Functions --- #
func _process(delta):
	needle_pos -= delta
	
	needles[0].rotation_degrees = 90 - 180 * needle_pos * rotation_speed
	if needles[0].rotation_degrees > 90:
		if needles[0].visible:
			Globals.timing_mods.append(POOR_MULT)
		needles[0].visible = false

func _input(event):
	if not (visible and event is InputEventKey and event.is_pressed()):
		return
	
	if needle_pos < PERF_THRESHOLD:
		Globals.timing_mods.append(PERF_MULT)
		needles[0].visible = false
	elif needle_pos > 0:
		Globals.timing_mods.append(GOOD_MULT)
		needles[0].visible = false
	else:
		Globals.timing_mods.append(POOR_MULT)
		needles[0].visible = false

func setup_timing(timings: Array[float]) -> void:
	backing.material.set_shader_parameter('threshold', PERF_THRESHOLD * rotation_speed)
	
	needle_pos = timings[0]
	needles[0].rotation_degrees = 90 - 180 * needle_pos * rotation_speed
	needles[0].visible = true
