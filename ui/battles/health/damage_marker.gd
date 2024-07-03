class_name DamageMarker
extends Node

# --- Variables --- #
@export var wait_time: float = 0.5
@export var fade_time: float = 0.5

@export var dmg_label: RichTextLabel

var tween: Tween

# --- Functions --- #
func _ready() -> void:
	dmg_label.clip_contents = false

func _on_lost_health(dmg: int) -> void:
	set_text(dmg)
	start_fade()

func detatch() -> void:
	reparent($"../..")
	
	if tween and tween.is_running():
		tween.tween_callback(queue_free)
	else:
		queue_free()

func start_fade():
	if tween:
		tween.kill()
	tween = create_tween()
	
	dmg_label.modulate.a = 1.0
	
	tween.tween_interval(wait_time)
	tween.tween_property(dmg_label, 'modulate:a', 0.0, fade_time)

func set_text(dmg: int):
	dmg_label.text = "[center]" + str(dmg)
