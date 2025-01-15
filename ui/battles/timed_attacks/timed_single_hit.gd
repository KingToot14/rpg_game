class_name TimedSingleHit
extends Control

# --- Variables --- #
@export var starting_radius := 30
@export var target_radius := 8
@export var visible_frames := 30

@export_group("Colors")
@export var perf_color := Color.WHITE
@export var good_color := Color.WHITE
@export var poor_color := Color.WHITE
@export var norm_color := Color.WHITE

var curr_ring := 0
var loaded_rings := 0

var active := false

# --- Constants --- #
const PERF_THRESHOLD := 10		# 0.1667s
const GOOD_THRESHOLD := 30		# 0.5000s

# --- References --- #
@onready var target_rect := %'target' as ColorRect

var rings: Array[ColorRect] = []
var ring_pos: Array[int] = []
var ring_reps: Array[int]

# --- Functions --- #
func _ready() -> void:
	for child in get_children():
		if "ring" in child.name:
			rings.append(child)
	
	hide()

func _physics_process(_delta: float) -> void:
	if not active:
		return
	
	for i in range(loaded_rings):
		if i < curr_ring:
			rings[i].color.a = 0
			continue
		
		ring_pos[i] -= 1
		
		# update radius and alpha
		rings[i].color.a = 1.0 - (1.0 * ring_pos[i] / visible_frames)
		rings[i].material.set_shader_parameter('radius', (1.0 * ring_pos[i] / visible_frames) * starting_radius + target_radius - 2)
	
	if curr_ring >= loaded_rings:
		return
	
	if visible and ring_pos[curr_ring] < 0:
		set_result(&'poor')
		target_rect.color = poor_color

func _input(event) -> void:
	if not (active and event.is_pressed() and curr_ring < loaded_rings):
		return
	if not (event is InputEventKey or event is InputEventMouseButton):
		return
	
	if ring_pos[curr_ring] < -2 or ring_pos[curr_ring] > GOOD_THRESHOLD:
		set_result(&'poor')
		target_rect.color = poor_color
	elif ring_pos[curr_ring] < PERF_THRESHOLD:
		set_result(&'perf')
		target_rect.color = perf_color
	else:
		set_result(&"good")
		target_rect.color = good_color

func setup_timing(timings: Array[Array]) -> void:
	curr_ring = 0
	loaded_rings = len(timings)
	
	ring_pos = []
	ring_reps = []
	
	target_rect.color = norm_color
	for i in range(loaded_rings):
		ring_pos.append(timings[i][0])
		ring_reps.append(timings[i][1])
		rings[i].color.a = 1.0 - float(ring_pos[i]) / visible_frames
		rings[i].material.set_shader_parameter('radius', (float(ring_pos[i]) / visible_frames) * starting_radius + target_radius - 2)

func activate() -> void:
	active = true
	modulate.a = 0
	show()
	
	var tween = create_tween()
	
	tween.tween_property(self, ^'modulate:a', 1.0, 0.10)

func deactivate() -> void:
	active = false
	for ring in rings:
		ring.color.a = 0
	
	var tween = create_tween()
	
	tween.tween_interval(0.50)
	tween.tween_property(self, ^'modulate:a', 0.0, 0.10)
	
	tween.finished.connect(hide)

func set_result(result: StringName) -> void:
	for rep in ring_reps[curr_ring]:
		Globals.timing_mods.append(result)
	
	curr_ring += 1
	
	if curr_ring >= loaded_rings:
		deactivate()
