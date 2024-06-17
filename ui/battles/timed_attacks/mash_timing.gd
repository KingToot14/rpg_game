class_name MashTiming
extends Control

# --- Variables --- #
var count := 0
var target := 0
var timing := 0.0

var active := false

# --- References --- #
@onready var count_label := $"count" as RichTextLabel

# --- Constants --- #
const GOOD_THRESHOLD := 0.70

# --- Functions --- #
func _input(event: InputEvent) -> void:
	if not (active and event.is_pressed()):
		return
	if not (event is InputEventKey or event is InputEventMouseButton):
		return
	
	count += 1
	
	count_label.text = "[center]" + str(count) + "/" + str(target)
	
	if count >= target:
		submit_result()

func setup_timing(time: float, targ: int = 10) -> void:
	visible = true
	
	timing = time
	target = targ
	count = 0
	
	count_label.text = "[center]" + str(count) + "/" + str(target)

func set_active() -> void:
	active = true
	get_tree().create_timer(timing).timeout.connect(submit_result)

func submit_result() -> void:
	if not visible:
		return
	
	if count >= target:
		set_result(&'perfect')
	elif count >= target * GOOD_THRESHOLD:
		set_result(&'good')
	else:
		set_result(&'poor')

func set_result(result: StringName) -> void:
	Globals.timing_mods.append(result)
	Globals.ui_manager.show_timing_result(result)
	
	visible = false
	active = false
