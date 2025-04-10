class_name DamageMarker
extends Node2D

# --- Variables --- #
@export var wait_time: float = 0.5
@export var fade_time: float = 0.5

@export var dmg_label: RichTextLabel
@export var weak_color := Color.WHITE
@export var normal_color := Color.WHITE
@export var resist_color := Color.WHITE
@export var heal_color := Color.WHITE

var tween: Tween
var origin: Vector2

# --- Functions --- #
func _ready() -> void:
	dmg_label.clip_contents = false
	origin = position

func _on_lost_health(dmg_chunk: Dictionary) -> void:
	dmg_label.text = "[center]"
	
	# check if move missed
	if not dmg_chunk.get(&'move_hit', true):
		dmg_label.text = "[color=%s]Missed!" % resist_color.to_html()
		start_fade()
		return
	
	# display crits
	var crits = dmg_chunk.get(&'crits_hit', 0)
	if crits > 0:
		if crits == 1:
			dmg_label.text += "Crit!"
		else:
			dmg_label.text += "Crit x%d!" % crits
		
		dmg_label.text += "\n"
	
	# calculate color
	var element_mod = dmg_chunk.get(&'element_mod', 0.0)
	
	if element_mod < -0.01:
		dmg_label.text += "[color=%s]" % weak_color.to_html()
	elif element_mod < 0.01:
		dmg_label.text += "[color=%s]" % normal_color.to_html()
	elif element_mod <= 1.0:
		dmg_label.text += "[color=%s]" % resist_color.to_html()
	else:
		dmg_label.text += "[color=%s]" % heal_color.to_html()
	
	dmg_label.text += "%d" % dmg_chunk[&'damage']
	
	# randomize position
	position = Vector2(
		origin.x + randi_range(-2, 2),
		origin.y + randi_range(-2, 2)
	)
	
	# show marker
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
