class_name DamageMarker
extends Node2D

# --- Variables --- #
@export var wait_time: float = 0.5
@export var fade_time: float = 0.5

@export var text_color: Color = Color.WHITE

@export var dmg_label: Label
@export var crit_label: Label

var dmg_tween: Tween
var crit_tween: Tween

# --- Functions --- #
func start_fade():
	set_text_alpha(1.0, dmg_label)
	set_text_alpha(1.0, crit_label)
	
	tween_fade(dmg_tween, dmg_label)
	tween_fade(crit_tween, crit_label)

func tween_fade(tween: Tween, label: Label) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	
	tween.tween_interval(wait_time)
	tween.tween_method(set_text_alpha.bind(label), 1.0, 0.0, fade_time)
	tween.finished.connect(hide)

func set_text(dmg: int, crit: int):
	dmg_label.text = str(dmg)
	
	crit_label.visible = crit > 0
	crit_label.text = "Crit"
	
	if crit > 1:
		crit_label.text += " x" + str(crit)

func set_text_alpha(alpha: float, label: Label):
	text_color.a = alpha
	
	label.add_theme_color_override('font_color', text_color)
