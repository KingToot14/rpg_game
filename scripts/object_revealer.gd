class_name ObjectRevealer
extends Sprite2D

# --- Variables --- #
@export var transparency: float = 0.5
@export var tween_speed: float = 0.5

# --- References --- #
var tween: Tween

# --- Functions --- #
func set_visibility_state(_body: Node2D, state: bool) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	
	if state:
		tween.tween_method(set_transparency, transparency, 0.0, tween_speed).set_trans(Tween.TRANS_LINEAR)
	else:
		tween.tween_method(set_transparency, 0.1, transparency, tween_speed).set_trans(Tween.TRANS_LINEAR)

func set_transparency(value: float) -> void:
	material.set_shader_parameter('transparency', value)
