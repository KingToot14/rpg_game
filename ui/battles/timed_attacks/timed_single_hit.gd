class_name TimedSingleHit
extends Control

# --- Variables --- #
@export var rotation_speed: float = 0.5

@export var needles: Array[Node2D] = []
var needle_pos: float = 0.0

# --- Constants --- #
const POOR_MULT: float = 0.90
const GOOD_MULT: float = 1.00
const PERF_MULT: float = 1.50

const PERF_TOLERANCE: float = 0.10

# --- Functions --- #
func _process(delta):
	needle_pos -= delta
	
	needles[0].rotation_degrees = 45 - 180 * needle_pos
	if needles[0].rotation_degrees > 90:
		if needles[0].visible:
			Globals.timing_mods.append(POOR_MULT)
		needles[0].visible = false

func _input(event):
	if not (visible and event is InputEventKey and event.is_pressed()):
		return
	
	if abs(needle_pos) < PERF_TOLERANCE:
		print("PERFECT")
		Globals.timing_mods.append(PERF_MULT)
		needles[0].visible = false
	elif needle_pos > 0:
		print("GOOD")
		Globals.timing_mods.append(GOOD_MULT)
		needles[0].visible = false
	else:
		print("POOR")
		Globals.timing_mods.append(POOR_MULT)
		needles[0].visible = false

func setup_timing(timings: Array[float]) -> void:
	needle_pos = timings[0]
	needles[0].rotation_degrees = 45 - 180 * needle_pos
	needles[0].visible = true
