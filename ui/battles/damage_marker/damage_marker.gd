class_name DamageMarker
extends Control

# --- Variables --- #
@export var wait_time: float = 0.5
@export var fade_time: float = 0.5

@export var text_color: Color = Color.WHITE

# --- References --- #
@onready var dmg_label := $"dmg_label" as Label
@onready var crit_label := $"crit_label" as Label

# --- Functions --- #
func start_fade():
	set_tween(dmg_label)
	set_tween(crit_label)

func set_tween(label: Label) -> void:
	var tween = create_tween()
	tween.tween_interval(wait_time)
	tween.tween_method(set_text_alpha.bind(label), 1.0, 0.0, fade_time)

func set_text(dmg: int, crit: int):
	dmg_label.text = str(dmg)
	
	crit_label.visible = crit > 0
	crit_label.text = "Crit"
	
	if crit > 1:
		crit_label.text += " x" + str(crit)

func set_text_alpha(alpha: float, label: Label):
	text_color.a = alpha
	
	label.add_theme_color_override('font_color', text_color)
