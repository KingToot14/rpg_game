class_name TargetingManager
extends Node

# --- Signals --- #
signal selected(entity: Entity)

# --- Variables --- #
var targetable := false
var is_mouse_over := false

@export var targeting_marker: Node2D
var targeting_origin: float
var targeting_tween: Tween

# --- References --- #
@onready var parent := $"../.." as Entity

# --- Functions --- #
func _ready() -> void:
	targeting_origin = targeting_marker.position.y
	targeting_marker.visible = true
	targeting_marker.modulate.a = 0

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT:
		return
	if not (event.pressed and is_mouse_over):
		return
	
	select()

func select() -> void:
	selected.emit(parent)

func _on_mouse_entered():
	is_mouse_over = true
	targeting_marker.frame = 1
	
	targeting_tween = create_tween().set_loops(0)
	targeting_tween.tween_property(targeting_marker, 'position:y', targeting_origin - 4, 0.75)
	targeting_tween.tween_property(targeting_marker, 'position:y', targeting_origin, 0.0)

func _on_mouse_exited():
	is_mouse_over = false
	targeting_marker.frame = 0
	
	if targeting_tween:
		targeting_tween.stop()
		targeting_marker.position.y = targeting_origin

func set_targetable(val: bool) -> void:
	targetable = val
	
	var tween = create_tween().set_parallel()
	
	if targetable:
		targeting_marker.modulate.a = 0
		targeting_marker.position.y = targeting_origin + 4
		tween.tween_property(targeting_marker, 'modulate:a', 1.0, 0.25)
		tween.tween_property(targeting_marker, 'position:y', targeting_origin, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	else:
		tween.tween_property(targeting_marker, 'modulate:a', 0.0, 0.25)
		tween.tween_property(targeting_marker, 'position:y', targeting_origin + 4, 0.25)
