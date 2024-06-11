extends CanvasLayer

# --- Variables --- #
@export_group("Timings")
@export var fade_time := 0.15
@export var swipe_time := 0.20
var swipe_dir: Vector2
@export var circle_time := 0.25
@export var split_time := 0.5

# --- References --- #
@onready var fade_rect := $"fade_rect" as ColorRect
@onready var swipe_rect := $"swipe_rect" as ColorRect
@onready var circle_rect := $"circle_rect" as ColorRect

# --- Functions --- #
func reset_all() -> void:
	fade_rect.modulate.a = 0.0
	set_swipe_offset(Vector2.ZERO)
	set_swipe_separation(Vector2.ONE)
	set_cutoff(0.0)

#region Fade
func play_fade() -> float:
	var tween = create_tween()
	
	tween.tween_property(fade_rect, 'modulate:a', 1.0, fade_time)
	
	return fade_time

func end_fade() -> void:
	var tween = create_tween()
	
	tween.tween_property(fade_rect, 'modulate:a', 0.0, fade_time)
#endregion

#region Swipe
func play_swipe(direction: Vector2) -> float:
	var tween = create_tween()
	
	swipe_dir = direction
	set_swipe_separation(Vector2.ONE)
	tween.tween_method(set_swipe_offset, Vector2.ZERO, swipe_dir, swipe_time)
	
	return swipe_time

func end_swipe() -> void:
	var tween = create_tween()
	
	tween.tween_method(set_swipe_offset, -swipe_dir, Vector2.ZERO, swipe_time)

func set_swipe_offset(val: Vector2) -> void:
	swipe_rect.material.set_shader_parameter('offset', val)

func set_swipe_separation(val: Vector2) -> void:
	swipe_rect.material.set_shader_parameter('separation', val)
#endregion

#region Circle
func play_circle() -> float:
	var tween = create_tween()
	
	tween.tween_method(set_cutoff, 0.0, 1.0, circle_time)
	
	return circle_time

func end_circle() -> void:
	var tween = create_tween()
	
	tween.tween_method(set_cutoff, 1.0, 0.0, circle_time)

func set_cutoff(val: float) -> void:
	circle_rect.material.set_shader_parameter('cutoff', val)
#endregion

#region Split
func play_split(horizontal: bool = false) -> float:
	var tween = create_tween()
	var end = Vector2(1.0, 0.0)
	
	if horizontal:
		end = Vector2(0.0, 1.0)
	
	set_swipe_offset(Vector2.ZERO)
	tween.tween_method(set_swipe_separation, Vector2.ONE, end, split_time)
	
	return split_time

func end_split(horizontal: bool = false) -> void:
	var tween = create_tween()
	
	var start = Vector2(1.0, 0.0)
	
	if horizontal:
		start = Vector2(0.0, 1.0)
	
	set_swipe_offset(Vector2.ZERO)
	tween.tween_method(set_swipe_separation, start, Vector2.ONE, split_time)
#endregion
