class_name StatusEffectButton
extends TextureRect

# --- Variables --- #
var effect: StatusEffect
var info: StatusEffectInfo

# --- References --- #
@onready var stacks_label := $"stacks" as RichTextLabel

# --- Functions --- #
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	if not effect:
		return
	
	Tooltip.set_width(100)
	Tooltip.set_title_text(info.get_effect_name(effect.stage))
	Tooltip.set_body_text(info.get_description(effect.stage))
	Tooltip.show_tooltip()

func _on_mouse_exited() -> void:
	if not effect:
		return
	
	Tooltip.hide_tooltip()

func set_effect(new_effect: StatusEffect) -> void:
	# clear tooltip if just removed
	if effect and not new_effect:
		if Tooltip.has_title(StatusEffectHelper.get_effect(effect.key).get_effect_name(effect.stage)):
			Tooltip.hide_tooltip()
	
	effect = new_effect
	
	visible = not not effect
	
	if not effect:
		return
	
	info = StatusEffectHelper.get_effect(effect.key)
	
	texture = info.small_icon
	
	if effect.max_stack > 1:
		stacks_label.text = " " + str(effect.stacks)
	else:
		stacks_label.text = ""
