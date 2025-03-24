class_name Tooltip
extends Control

# --- Variables --- #
@export var side_padding := Vector2(20, 20)

@export var pointer: Control
@export var pointer_offset := Vector2(0, -6)
var point_position: Vector2

var curr_id: StringName

var tween: Tween

# --- Functions --- #
func _ready() -> void:
	modulate.a = 0.0

#region Visibility
func show_tooltip() -> void:
	show()
	if tween:
		tween.kill()
	tween = create_tween()
	
	tween.tween_property(self, ^'modulate:a', 1.0, 0.15)
	tween.finished.connect(show)

func hide_tooltip() -> void:
	curr_id = &""
	if tween:
		tween.kill()
	tween = create_tween()
	
	tween.tween_property(self, ^'modulate:a', 0.0, 0.15)
	tween.finished.connect(hide)

#endregion

#region Utility
func showing_id(id: StringName) -> bool:
	return curr_id == id

#endregion

#region Positioning
func point_to(pos: Vector2) -> void:
	# update position
	point_position = pos
	fit_bounds()
	
	# make sure pointer stays in place
	pointer.global_position = point_position + pointer_offset - pointer.size / 2
	
	# show if hidden
	if modulate.a < 0.5:
		show_tooltip()

func fit_bounds() -> void:
	global_position = Vector2(point_position.x - size.x / 2, point_position.y - size.y) + pointer_offset

#endregion
