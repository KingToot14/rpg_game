class_name TimedSingleHit
extends Control

# --- Variables --- #
@export var rotation_speed: float = 0.5

@export var needles: Array[Node2D] = []
var target: float = 0.75
var needle_pos: float = 0.0

# --- Constants --- #
const POOR_MULT: float = 0.90
const GOOD_MULT: float = 1.00
const PERF_MULT: float = 1.50

const PERF_TOLERANCE: float = 0.10

# --- Functions --- #
func _process(delta):
	needle_pos += delta

func _input(event):
	if not event is InputEventKey:
		return
	
	var diff = target - needle_pos
	if abs(diff) < PERF_TOLERANCE:
		print("PERFECT")
		Globals.timing_mods.append(PERF_MULT)
	elif diff > 0:
		print("GOOD")
		Globals.timing_mods.append(GOOD_MULT)
	else:
		print("POOR")
		Globals.timing_mods.append(POOR_MULT)

func setup_timing(timings: Array[int]) -> void:
	target = timings[0]
	needle_pos = 0
