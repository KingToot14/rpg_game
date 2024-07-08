class_name StatusEffectButton
extends TextureRect

# --- Variables --- #
var effect: StatusEffect

# --- Functions --- #
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	if not effect:
		return
	
	Tooltip.set_title_text(effect.name)
	Tooltip.set_body_text(effect.description)
	Tooltip.show_tooltip()

func _on_mouse_exited() -> void:
	if not effect:
		return
	
	Tooltip.hide_tooltip()

func set_effect(new_effect: StatusEffect) -> void:
	effect = new_effect
	
	visible = not not effect
	
	if not effect:
		return
	
	$"stacks".text = " " + str(effect.stacks)
